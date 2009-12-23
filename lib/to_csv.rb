require 'fastercsv'
require 'ostruct'
require 'active_support'
require 'to_csv/csv_converter'

module ToCSV  
  mattr_accessor :byte_order_marker, :locale, :primary_key, :timestamps
  mattr_accessor :csv_options
  self.csv_options = { :col_sep => ';' }
end

class Array
  
  #
  # Returns a CSV string.
  #
  # ==== Available Options:
  #
  # 1. *options*
  #    +byte_order_marker+::
  #      If true, a Byte Order Maker (BOM) will be inserted at
  #      the beginning of the output. It's useful if you want to force
  #      MS Excel to read UTF-8 encoded files, otherwise it will just
  #      decode them as Latin1 (ISO-8859-1). Default: +false+.
  #    +timestamps+::
  #      Include timestamps (+created_at+ and +updated_at+) as columns.
  #      Default: +false+.
  #    +only+::
  #      Same behavior as with the +to_json+ method.
  #    +except+::
  #      Same as +only+ option.
  #    +methods+::
  #      Accepts a symbol or an array with additional methods to be included.
  #    +primary_key+::
  #      Has precedence over any other option. If +true+ the object's primary
  #      key will be added as an attribute, which in turn will be mapped to
  #      a CSV column. Default: +false+.
  #    +headers+::
  #       If this list is <tt>nil</tt> then headers will be in alphabetical order.
  #       If it is an empty array or <tt>false</tt>, no headers will be shown.
  #       If it is non empty, headers will sorted in the order specified.
  #       <tt>:all</tt> can be used as a placeholder for all attributes not
  #       explicitly named.
  #    +locale+::
  #      In a Rails environment, it will automatically take the current locale
  #      and will use it to translate the columns to friendly headers.
  #      Methods will be translated from
  #      <tt>[:activerecord, :attributes, <model>]</tt>. If the translation
  #      is missing, then a simple humanize will be called.
  #
  # 2. *csv_options*
  #    Accepts all options listed in <tt>FasterCSV::DEFAULT_OPTIONS</tt>.
  #
  def to_csv(options = {}, csv_options = {}, &block)
    return '' if empty?
    csv_converter = ToCSV::Converter.new(self, options, csv_options, &block)
    csv_converter.to_csv
  end
end