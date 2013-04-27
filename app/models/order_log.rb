require 'csv'

# An OrderLog represents the collection of orders added through uploading
# a tab-delimited file.  It is responsible for aggregate reporting on said
# collection, such as the calculation of gross revenue.
class OrderLog < ActiveRecord::Base
  validates :source_data, :presence => true
  validates_associated :orders
  validate :source_data_is_tab_separated, :if => :source_data

  has_many :orders
  belongs_to :uploader, :class_name => 'User'

  delegate :email, :to => :uploader, :prefix => true, :allow_nil => true

  # Validation method - rudimentary checking to see if we have source_data
  # that is possibly tab-separated and can be parsed by CSV.
  def source_data_is_tab_separated
    unless source_data =~ /\t/
      raise CSV::MalformedCSVError
    end
    CSV.parse(source_data, :headers => true, :col_sep => "\t")
  rescue CSV::MalformedCSVError => e
    errors.add(:source_data, :not_tab_separated)
  end

  # This method takes either an IO instance (a File or StringIO, for example)
  # or something that can be stored as a string.  It has a side effect of also
  # setting the #filename attribute if the passed in IO object responds to
  # #original_filename, which is the case when this was from a file upload on
  # a form.
  def source_data=(string_or_io)
    data = string_or_io.respond_to?(:read) ? string_or_io.read : string_or_io
    if string_or_io.respond_to?(:original_filename)
      self.filename = string_or_io.original_filename
    end
    write_attribute(:source_data, data)
  end

  after_create :create_orders!
  after_validation do
    if errors[:orders].present?
      errors.add(:source_data, :has_invalid_orders)
    end
  end

  # Every time we request the gross revenue on an order log, we'll run
  # through all the orders and add up their totals.  We'll memoize it per
  # instantiation of the order log, but naturally this is still going to
  # be a heavy operation, so we'll also store the value in a cache
  # column, which can be requested using an option passed in to this
  # method.
  # 
  # Previously we were performing a calculation straight out of source data,
  # but we moved away from it becase it was too implementation specific, and
  # violated separation - it is the Order object's job to calculate a total.
  def gross_revenue(options = {})
    if options[:cached] && cents = gross_revenue_cents
      Money.new(cents)
    else
      @gross_revenue ||= begin
        gross_revenue_total = orders.inject(Money.new(0)) {
          |total, order| total += order.total
        }
        self.gross_revenue_cents = gross_revenue_total.cents
        save! if persisted? && changed?
        gross_revenue_total
      end
    end
  end

  # Is this order log record stale?  We determine staleness by inspecting
  # #updated_at - if the record hasn't been updated in 10 minutes, it's stale.
  # This can then be used to determine whether or not to pull data from the
  # cache.
  def stale?
    updated_at < (Time.now - 1.minute)
  end

  # Directly sum the gross revenue from the source data, by enumerating
  # the order rows and aggregating the quantity * price.  This is deprecated
  # in the app now, but I'm leaving it in place for reviewers to see -
  # this is the more performant way to retrieve this data.
  def aggregate_gross_revenue_from_source_data
    order_lines_from_source_data.inject(0) do |amount, order|
      if order['item price'] && order['purchase count']
        amount += order['item price'].to_d * order['purchase count'].to_i
      end
    end
  end

  # Parse the source data as tab-delimited text, and construct an array of
  # hashes, each hash representing an order from the provided file.  Note
  # that this method does not do any filtering based on business rules; you
  # can end up with hashes that make no sense if the source data is not
  # what you expect.
  def order_lines_from_source_data
    CSV.parse(source_data, :headers => true, :col_sep => "\t").map(&:to_hash)
  end

  # Generate an order for each line in the source data, and add that order to
  # #orders.
  def create_orders!(options = {})
    # This first #save! is unfortunately necessary so we don't trigger the
    # callback again within the transaction
    save!
    if orders.empty? || options[:force] == true
      OrderLog.transaction do
        self.orders.destroy_all
        order_lines_from_source_data.each do |order_line|
          order = Order.from_log_entry(order_line)
          orders << order
        end
        save!
      end
    end
    orders(true)
  end
end
