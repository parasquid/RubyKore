module RubyKore
  module Messaging
    class Message
      attr_reader :name
      attr_accessor :header

      # raw: the raw data
      # format_string: see http://www.ruby-doc.org/core/classes/String.html#M001112
      # fields: the message fields (comma separated)
      def initialize(raw, name, format_string, fields)
        @raw, @name, @format_string, @fields = raw, name, format_string, fields

        # create the attributes hash
        values = @raw.unpack(format_string)
        keys = @fields.split(',').each{ |field| field.strip }
        @attributes = combine_to_hash(keys, values)

        # convert string keys to symbols
        @attributes.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

        # create dynamic instance methods for each field
        @attributes.each_key do |key|
          (class << self; self; end).send(:define_method, key) do |*splat|
            if(splat.empty?)
              @attributes[key]
            else
              @attributes[key] = splat.first
            end
          end
        end
      end

      def method_missing(symbol, *args, &block)
        super
      end

      def respond_to?(method_sym, include_private = false)
        @attributes.has_key?(method_sym.to_s) ? true : super
      end

      private
      # see http://rosettacode.org/wiki/Hash_from_two_arrays#Ruby
      def combine_to_hash(keys, values)
        Hash[keys.zip(values)]
      end
    end
  end
end
