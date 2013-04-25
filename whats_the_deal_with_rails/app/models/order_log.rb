require 'csv'

# An OrderLog represents the collection of orders added through uploading
# a tab-delimited file.  It is responsible for aggregate reporting on said
# collection, such as the calculation of gross revenue.
class OrderLog < ActiveRecord::Base
  include MoneyColumn::StoresMoney
  stores_money :gross_revenue, :cents_attribute => "gross_revenue_cents"

  validates :source_data, :presence => true
  validate :source_data_is_tab_separated, :if => :source_data

  has_many :orders

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

  before_save :calculate_gross_revenue!

  # This method will be called every time the object is saved;
  # if we have source data, it will set gross_revenue to the calculated
  # gross revenue from parsing the source data (see
  # #aggregate_gross_revenue_from_source_data).  If no source data
  # exists yet, we'll just set gross_revenue to nil.
  def calculate_gross_revenue!
    self.gross_revenue = if source_data
      aggregate_gross_revenue_from_source_data
    else
      nil
    end
    gross_revenue || 0
  end

  # Directly sum the gross revenue from the source data, by enumerating
  # the order rows and aggregating the quantity * price.
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
  def create_orders!
    OrderLog.transaction do
      order_lines_from_source_data.each do |order_line|
        order = Order.from_log_entry(order_line)
        order.order_log = self
        order.save!
      end
      save!
    end
    orders(true)
  end
end
