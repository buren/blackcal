# Blackcal

Create blacklist rules for calendars with ease. Supports recurring rules for certain weekdays, date numbers, hour of day.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blackcal'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blackcal

## Usage

```ruby
rule = Blackcal::Rule.new(start_hour: 18, end_hour: 7)

rule.open?(Time.parse('2019-01-01 19:00'))
# => false

rule.open?(Time.parse('2019-01-01 11:00'))
# => true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buren/blackcal.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
