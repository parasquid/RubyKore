$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/lib")

require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'eventmachine'
require 'Network/loop'
require 'Messaging/queue'
require 'Messaging/tokenizer'
require 'InputHandler/keyboard'

class Bot
  def initialize(config)
    @ip, @port = config[:network][:ip], config[:network][:port]
    kickoff
  end

  def kickoff
    connection = EM.connect @ip, @port, RubyKore::Network::Loop do |conn|
      # send initial connect handshake
      conn.send_data("\xdb\x01") # encrypted login
    end
    connection.on_receive_data do |messages|
      messages.each do |message|
        p message.secure_key if !message.nil?
      end
    end

    # Initialize input handlers
    # * keyboard
    # * socket (json)
    EM.open_keyboard(RubyKore::InputHandler::Keyboard)
  end
end

if __FILE__ == $0
  EM.run do
    config = YAML.load_file("config.yml")
    Bot.new(config)
  end
end