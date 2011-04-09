module RubyKore
  module Messaging
    class Queue
      def initialize(tokenizer)
        @messages = []
        @tokenizer = tokenizer
      end

      def append(data)
        # append data to the stream
        @messages << @tokenizer.tokenize(data)
      end

      # Returns the next complete message
      # Returns nil if the queue is empty
      def next
        #(message = @messages.shift).empty? ? nil : message
        @messages.shift
      end

    end
  end
end