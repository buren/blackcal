# frozen_string_literal: true

require 'time'

require 'blackcal/range/time_range'
require 'blackcal/range/time_of_day_range'
require 'blackcal/range/week_of_month_range'
require 'blackcal/range/weekday_range'
require 'blackcal/range/month_range'
require 'blackcal/range/day_range'
require 'blackcal/slot_matrix'

module Blackcal
  # Represents a schedule
  class Schedule
    # Initialize rule
    # @param start_time [Time, Date, String, nil]
    # @param finish_time [Time, Date, String, nil]
    # @param start_hour [TimeOfDay, Time, Integer, nil]
    # @param finish_hour [TimeOfDay, Time, Integer, nil]
    # @param months [Array<String>, Array<Symbol>, String, Symbol, nil]
    # @param weekdays [Array<String>, Array<Symbol>, String, Symbol, nil]
    # @param days [Array<Integer>, Integer, nil]
    # @see TimeRange#initialize
    # @see TimeOfDayRange#initialize
    # @see MonthRange#initialize
    # @see WeekdayRange#initialize
    # @see DayRange#initialize
    def initialize(
      start_time: nil,
      finish_time: nil,
      start_hour: nil,
      finish_hour: nil,
      months: nil,
      weekdays: nil,
      weeks_of_month: nil,
      days: nil
    )
      if start_time || finish_time
        @rule_range = TimeRange.new(parse_time(start_time), parse_time(finish_time))
      end

      if start_hour || finish_hour
        @time_of_day = TimeOfDayRange.new(start_hour, finish_hour)
      end

      if months
        @months = MonthRange.new(months)
      end

      if weeks_of_month
        @weeks_of_month = WeekOfMonthRange.new(weeks_of_month)
      end

      if weekdays
        @weekdays = WeekdayRange.new(weekdays)
      end

      if days
        @days = DayRange.new(days)
      end
    end

    # Returns true if calendar is open for timestamp
    # @param [Time] timestamp
    # @return [Boolean]
    def cover?(timestamp)
      timestamp = parse_time(timestamp)
      return false if @rule_range && !@rule_range.cover?(timestamp)

      ranges = [@months, @weekdays, @days, @time_of_day, @weeks_of_month].compact
      return false if ranges.empty?

      ranges.all? { |range| range.cover?(timestamp) }
    end

    # Returns schedule represented as a matrix
    # @param start_date [Date]
    # @param finish_date [Date]
    # @return [Array<Array<Boolean>>]
    def to_matrix(start_date:, finish_date:, resolution: :hour)
      start_time = parse_time(start_date).to_time
      finish_time = parse_time(finish_date).to_time
      slots = resolution == :hour ? 24 : 24 * 60
      matrix = SlotMatrix.new(slots)

      # TODO: This is needlessly inefficient..
      time_range = TimeRange.new(start_time, finish_time)
      time_range.each(resolution: resolution) do |time|
        matrix << cover?(time)
      end

      matrix.data
    end

    private

    def parse_time(time)
      return Time.parse(time) if time.is_a?(String)
      time
    end
  end
end
