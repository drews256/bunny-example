require 'bunny'

class BunnySubscriberDeux
  attr_reader :connection, :channel, :exchange, :queue
  def initialize
    @connection = Bunny.new
    @connection.start
    @channel = connection.create_channel
    @queue = @channel.queue("other_task_queue", durable: true)

    #Instead of binding the queue when we create the exchange
    #We can bind after the fact, so adding queue to an exchange is no issue
    @exchange = @channel.exchange("task_fanout", type: "fanout")
    @queue.bind(@exchange)
  end

  def subscribe
    begin
      queue.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
        # Do something with the body
        puts "Recieved Body from Other Task Queue #{body}"
        # Acknowledge the message was delivered
        puts "Delivery info delivery Tag #{delivery_info.delivery_tag}"
        channel.ack(delivery_info.delivery_tag)
      end
    rescue Interrupt => _
      connection.close
    end
  end
end
