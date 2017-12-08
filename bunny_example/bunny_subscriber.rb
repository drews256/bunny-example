require 'bunny'

class BunnySubscriber
  attr_reader :connection, :channel, :queue
  def initialize
    @connection = Bunny.new
    @connection.start
    @channel = connection.create_channel
    # Note here the Queue is already bound to the exchange
    @queue = @channel.queue("task_queue", durable: true)
  end

  def subscribe
    begin
      queue.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
        # Do something with the body
        puts "Received Body from Task Queue #{body}"
        # Acknowledge the message was delivered
        puts "Delivery info delivery Tag #{delivery_info.delivery_tag}"
        channel.ack(delivery_info.delivery_tag)
      end
    rescue Interrupt => _
      #this connection is persistent
      connection.close
    end
  end
end
