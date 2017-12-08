require 'sneakers'
require 'sneakers/runner'
require 'logger'

class SneakersSubscriber
  include Sneakers::Worker
    attr_reader :changed_task, :tasks
    Sneakers.configure connection: Bunny.new,
      :exchange => 'task_fanout',
      :exchange_type => :fanout,
      :durable => false,
      :timeout_job_after => 30

      from_queue 'sneakers_queue',
      exchange: 'task_fanout',
      durable: false,
      exchange_type: :fanout

    def work(payload)
      logger.error("Received payload #{payload}")

      # Note how easy it is to acknowledge the message now!
      # With basic Sneakers workers, we can call ack!, requeue!, and reject!
      ack!
  end
end

r = Sneakers::Runner.new([SneakersSubscriber])
r.run
