# Metrico [early MVP] [specs required]

> NATS ruby client to write metrics
> Use it to push in InfluxDB format through NATS
> `https://docs.influxdata.com/influxdb/v1.2/write_protocols/line_protocol_tutorial/`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'metrico'
```

```
$ bundle install
```

```ruby
# config/initializers/metrico.rb
Metrico.configure do |config|
  config.app_name = 'app_name' # required
  config.hostname = 'globalhost' # required
  config.nats_connect_options = {
    servers: ['nats://telegraf-0.somenatsnode.com:4222']
  }
  # define lambdas for these callbacks if you need some
  config.on_error = ->{}
  config.on_reconnect = ->{}
  config.on_disconnect = ->{}
  config.on_close = ->{}
end
```
For more nats connect options see [https://github.com/nats-io/pure-ruby-nats/blob/master/lib/nats/io/client.rb#L154](https://github.com/nats-io/pure-ruby-nats/blob/master/lib/nats/io/client.rb#L154). You also can define most of all connection config via ENV variables.

## Usage
In your app you have to push metrics, passing name, hash of metric/value and hash of tags.

Examples:
```ruby
Metrico.push('3rd_party', {response_time: 1300, sidekiq_retry: 2}, {service: :first})

Metrico.push(
  'heartbeat',
  { cpu: 99, memory: 3200 }
)
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
