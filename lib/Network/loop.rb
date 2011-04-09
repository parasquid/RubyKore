module RubyKore
  module Network
    module Loop
      attr_accessor :message_lengths

      def post_init
      end

      def connection_completed
        p 'we are connected!'
        tokenizer = RubyKore::Messaging::Tokenizer.new(@message_lengths)
        @queue ||= RubyKore::Messaging::Queue.new(tokenizer)
      end

      def receive_data(data)
        @queue.append(data)
        process_callbacks
      end

      def unbind
        p "we got disconnected"
      end

      def on_receive_data(&block)
        @callbacks ||= []
        @callbacks << block
      end
      
      private
      def process_callbacks
        while ((message = @queue.next) != nil) do
          @callbacks.each { |c| c.call(message) }
        end
      end

    end
  end
end
