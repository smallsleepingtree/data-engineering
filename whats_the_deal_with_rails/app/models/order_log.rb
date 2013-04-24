require 'csv'

class OrderLog < ActiveRecord::Base
  validates :source_data, :presence => true
  validate :source_data_is_tab_separated, :if => :source_data

  def source_data_is_tab_separated
    unless source_data =~ /\t/
      raise CSV::MalformedCSVError
    end
    CSV.parse(source_data, :headers => true, :col_sep => "\t")
  rescue CSV::MalformedCSVError => e
    errors.add(:source_data, :not_tab_separated)
  end

  def source_data=(string_or_io)
    data = string_or_io.respond_to?(:read) ? string_or_io.read : string_or_io
    if string_or_io.respond_to?(:original_filename)
      self.filename = string_or_io.original_filename
    end
    write_attribute(:source_data, data)
  end
end
