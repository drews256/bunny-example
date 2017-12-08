### To Start
Dependencies: Ruby 2.4.2

Install the gems
1. gem install bundler
2. bundle install

Run the publisher in one irb session
`irb -r ./bunny_example.rb`
```ruby
bunny_publisher = BunnyPublisher.new
bunny_publisher.publish
```

Load the subscriber in another irb session
`irb -r ./bunny_example.rb`
```ruby
bunny_subscriber = BunnySubscriber.new
bunny_subscriber.subscribe
```
Load the second subscriber in another irb session
`irb -r ./bunny_example.rb`
```ruby
bunny_subscriber = BunnySubscriberDeux.new
bunny_subscriber.subscribe
```
Start the Sneakers worker
`ruby workers/sneakers_subscriber.rb`

When you publish in the publish session.
All subscribers should receive a message.
