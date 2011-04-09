require 'Messaging/message'

module RubyKore
  module Messaging
    class Tokenizer
      def initialize(message_lengths)
        @message_lengths = message_lengths
        p @message_lengths
        @buffer = ''
      end

      # returns an array of complete messages
      # nil if there are no complete messages
      def tokenize(data)
        # append latest data to buffer because buffer might be containing
        # incomplete messages
        @buffer << data
        messages = []

        # TODO: separate out into chunks
        chunk = data
        
        header = get_header(chunk)

        new_message = case header.unpack('H*').first.upcase
        #TODO: move message definitions to another file
        when '01DC' then Message.new(data, 'secure_login_key', 'x2 a*', 'secure_key')
        else nil
        end

        new_message.header = get_header(data) if !new_message.nil?
        messages << new_message
      end

      private
      def get_header(data)
        data[0, 2].reverse
      end
    end
  end
end
