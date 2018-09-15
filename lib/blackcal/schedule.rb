# frozen_string_literal: true

require 'time'

require 'blackcal/time_range'
require 'blackcal/time_of_day_range'
require 'blackcal/weekday_range'
require 'blackcal/day_range'

module Blackcal
  # Represents a schedule
  class Schedule
    # Initialize rule
    # @param start_time [Time, Date, String, nil]
    # @param finish_time [Time, Date, String, nil]
    # @param start_hour [Integer, nil]
    # @param finish_hour [Integer, nil]
    # @param weekdays [Array<String>, Array<Symbol>, String, Symbol, nil]
    # @param days [Array<Integer>, Integer, nil]
    def initialize(
      start_time: nil,
      finish_time: nil,
      start_hour: nil,
      finish_hour: nil,
      weekdays: nil,
      # weeks_of_month: nil, # TODO
      days: nil
    )
      @rule_range = TimeRange.new(parse_time(start_time), parse_time(finish_time)) if start_time || finish_time # rubocop:disable Metrics/LineLength
      @time_of_day = TimeOfDayRange.new(start_hour, finish_hour) if start_hour || finish_hour # rubocop:disable Metrics/LineLength
      @weekdays = WeekdayRange.new(weekdays) if weekdays
      @days = DayRange.new(days) if days
    end

    # Returns true if calendar is open for timestamp
    # @param [Time] timestamp
    # @return [Boolean]
    def cover?(timestamp)
      timestamp = parse_time(timestamp)
      return true if @rule_range && !@rule_range.cover?(timestamp)

      [@weekdays, @days, @time_of_day].each do |range|
        return true if range && !range.cover?(timestamp)
      end

      false
    end

    private

    def parse_time(time)
      return Time.parse(time) if time.is_a?(String)
      time
    end
  end
end
