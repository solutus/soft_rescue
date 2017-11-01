# SoftRescue 

This gem helps to handle exceptions in soft manner using configured modes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'soft_rescue'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install soft_rescue

## Usage

### Configuration
Code below may be placed to config/initializers/soft_rescue.rb (Rails) or anything like this file.

All params and whole block are optional.

```ruby
SoftRescue.configure do |config|
  config.logger = Logger.new
  config.enabled = Rails.env.production?
  config.capture_exception = -> exception { Raven.capture_exception(exception) }
end
```

Use `SoftRescue.call` method not to raise exception, but just log it and return result of on_failure.

```ruby

SoftRescue.call(on_failure: -> { email_me_about_something_wrong; Time.now }) do
  open("http://get-best-time") # raises StandardError
end
```

Another example.

```ruby
SoftRescue.call(on_failure: Time.now, message: "getting best time") do
  open("http://get-best-time") # raises StandardError
end
```

See more examples in test/

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/soft_rescue. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source undhttps://travis-ci.org/solutus/soft_rescue.svg?branch=masterer the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Build statuses

[![Build Status](https://travis-ci.org/solutus/soft_rescue.svg)](https://travis-ci.org/solutus/soft_rescue)


