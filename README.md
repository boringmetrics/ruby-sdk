# Boring Metrics Ruby SDK

This is a Ruby SDK for the Boring Metrics API. It provides a simple and efficient way to interact with the API from your Ruby applications.

## Supported Platforms

The SDK is available for the following platforms:

- [`boringmetrics`](https://github.com/boringmetrics/ruby-sdk/tree/main/packages/boringmetrics): SDK for Ruby
- [`boringmetrics-rails`](https://github.com/boringmetrics/ruby-sdk/tree/main/packages/boringmetrics-rails): SDK for Ruby on Rails

## Installation

Add this line to your application's Gemfile:

```ruby
# For plain Ruby applications
gem 'boringmetrics'

# For Rails applications
gem 'boringmetrics-rails'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install boringmetrics
$ gem install boringmetrics-rails
```

## Usage

### Ruby

```ruby
# Initialize the SDK
BoringMetrics.initialize("YOUR_API_TOKEN")

# Send a log
BoringMetrics.logs.send(
  type: "log",
  level: "info",
  message: "User signed in",
  data: { userId: "123" },
)

# Send multiple logs
BoringMetrics.logs.send_batch([
  { type: "log", level: "warn", message: "Something looks weird" },
  { type: "log", level: "error", message: "Something broke!", data: { error: "Connection timeout" } }
])

# Set a live metric value
BoringMetrics.lives.update(
  liveId: "metric-123",
  value: 42,
  operation: "set",
)

# Increment a live metric value
BoringMetrics.lives.update(
  liveId: "metric-123",
  value: 5,
  operation: "increment",
)
```

### Rails

In a Rails application, you can initialize the SDK in an initializer:

```ruby
# config/initializers/boringmetrics.rb
BoringMetrics::Rails.initialize("YOUR_API_TOKEN", {
  logsMaxBatchSize: 50,
  logsSendInterval: 10
})
```

The Rails integration automatically captures exceptions and logs them to BoringMetrics.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/boringmetrics/ruby-sdk.

## Contributors

Thanks to everyone who contributed to the Boring Metrics Ruby SDK!

<a href="https://github.com/boringmetrics/ruby-sdk/graphs/contributors">
  <img src="https://contributors-img.web.app/image?repo=boringmetrics/ruby-sdk" />
</a>

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
