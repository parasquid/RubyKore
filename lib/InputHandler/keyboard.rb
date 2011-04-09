module RubyKore
  module InputHandler
    module Keyboard
      include EM::Protocols::LineText2
      def initialize
        super
      end
      def receive_line data
        puts "I received the following line from the keyboard: #{data}"
      end
    end
  end
end