require 'csv'

# An OrderLog represents the collection of orders added through uploading
# a tab-delimited file.  It is responsible for aggregate reporting on said
# collection, such as the calculation of gross revenue.
class OrderLog < ActiveRecord::Base
  validates :source_data, :presence => true
  validate :source_data_is_tab_separated, :if => :source_data

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
end
