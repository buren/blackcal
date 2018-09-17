# Blackcal [![Build Status](https://travis-ci.com/buren/blackcal.svg?branch=master)](https://travis-ci.com/buren/blackcal)

Create blacklist rules for calendars with ease. Supports recurring rules for certain weekdays, date numbers, hour of day.

Born out of the idea to comparing schedules using matrix operations. This gem makes it easy to see whether if a time is covered by a certain schedule and generate a matrix representing what the schedule covers (hour our minute resolution).

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

The main parts are `Blackcal#schedule` for generating a schedule, `schedule#cover?` to see whether a time is covered by schedule and finally `schedule#to_matrix` that generates a schedule with given time resolution (hour our minute).

Schedule Mondays and Tuesdays
```ruby
schedule = Blackcal.schedule(weekdays: [:monday, :tuesday])
schedule.cover?('2019-01-01 19:00')
# => true
schedule.cover?('2019-01-02 19:00')
# => false
```

Schedule between 6pm and 7am every day
```ruby
schedule = Blackcal.schedule(start_hour: 18, finish_hour: 7)
schedule.cover?('2019-01-01 19:00')
# => true
schedule.cover?('2019-01-01 11:00')
# => false

# minutes are supported too
eighteen_thirty = Blackcal::TimeOfDay.new(18, 30)
schedule = Blackcal.schedule(start_hour: eighteen_thirty)
```

Schedule day 15 and 17 of month
```ruby
schedule = Blackcal.schedule(days: [15, 17])
schedule.cover?('2019-01-15 19:00')
# => true
schedule.cover?('2019-01-01 11:00')
# => false
```

Schedule first and third week of every month
```ruby
schedule = Blackcal.schedule(weeks_of_month: [1, 3])
schedule.cover?('2019-01-03 19:00')
# => true
schedule.cover?('2019-01-10 19:00')
# => false
```

Define when the schedule is active
```ruby
Blackcal.schedule(start_time: '2018-01-01 11:00', finish_time: '2019-01-01 11:00')
```

All options at once - schedule January, 3rd week, Mondays and Tuesdays, day 15-25, between 18pm and 7am
```ruby
schedule = Blackcal.schedule(
  months: [:january],
  weeks_of_month: [3],
  weekdays: [:monday, :tuesday],
  start_hour: 18, finish_hour: 7,
  days: (15..25).to_a
)
schedule.cover?('2018-01-16 06:00')
# => true
schedule.cover?('2018-01-16 08:00')
# => false
```

_Note_: `#cover?` supports `String` and `Time` objects. `start_hour` and `finish_hour` supports `Blackcal::TimeOfDay`, `Time` and `Integer` objects.

Matrix representation
```ruby
schedule = Blackcal.schedule(weekdays: :friday, start_hour: 0, finish_hour: 14)
schedule.to_matrix(start_date: '2018-09-14', finish_date: '2018-09-16')
# => [[true, ...], [false, ...]]

# defaults to hour resolution, but you can get minute resolution too
schedule = Blackcal.schedule(weekdays: :friday, start_hour: 0, finish_hour: 14)
schedule.to_matrix(resolution: :min, start_date: '2018-09-14', finish_date: '2018-09-16')
# => [[true, ...], [false, ...]]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buren/blackcal.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
