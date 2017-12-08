require 'bunny'
require 'json'

class BunnyPublisher
  attr_reader :connection, :channel, :exchange, :queue
  def initialize
    # Step 1. Create a new bunny connection
    @connection = Bunny.new

    # Step 3. Start a connection
    @connection.start

    # Step 4. Create a new channel
    @channel = connection.create_channel

    # Step 5. Connect to or Create a new Exchange from the channel
    @queue = @channel.queue("task_queue", :durable => true)

    # Step 6. Create an exchange
    @exchange = @channel.exchange("task_fanout", type: 'fanout')

    # Step 7. Bind the queue to the exchange
    @queue.bind(@exchange)
  end

  def publish
    # Step 8. Publish something!
    exchange.publish({"some": "serialized json"}.to_json)
  end

  def close_connection
    #Step 9. Close the connection
    connection.close
  end
end
