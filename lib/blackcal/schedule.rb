# frozen_string_literal: true

require 'time'

require 'blackcal/range/time_range'
require 'blackcal/range/time_of_day_range'
require 'blackcal/range/weeks_of_month_range'
require 'blackcal/range/weekday_range'
require 'blackcal/range/month_range'
require 'blackcal/range/day_range'
require 'blackcal/slot_matrix'

module Blackcal
  # Represents a schedule
  class Schedule
    # @return [TimeRange] the time the schedule is active
    attr_reader :time_range

    # @return [MonthRange] months when this schedule is active
    attr_reader :months

    # @return [TimeOfDay] time of day when this schedule is active
    attr_reader :time_of_day

    # @return [WeeksOfMonthRange] weeks of month when this schedule is active
    attr_reader :weeks_of_month

    # @return [DayRange] days when this schedule is active
    attr_reader :days

    # @return [WeekdayRange] weekdays when this schedule is active
    attr_reader :weekdays

    # Initialize schedule
    # @param start_time [Time, Date, String, nil]
    # @param finish_time [Time, Date, String, nil]
    # @param start_time_of_day [TimeOfDay, nil]
    # @param finish_time_of_day [TimeOfDay, nil]
    # @param months [Array<String>, Array<Symbol>, String, Symbol, nil]
    # @param weekdays [Array<String>, Array<Symbol>, String, Symbol, nil]
    # @param weeks_of_month [Array<Integer>, nil]
    # @param days [Array<Integer>, Integer, nil]
    # @see TimeRange#initialize
    # @see TimeOfDayRange#initialize
    # @see MonthRange#initialize
    # @see WeekdayRange#initialize
    # @see DayRange#initialize
    def initialize(
      start_time: nil,
      finish_time: nil,
      start_time_of_day: nil,
      finish_time_of_day: nil,
      months: nil,
      weekdays: nil,
      weeks_of_month: nil,
      days: nil
    )
      if start_time || finish_time
        @time_range = TimeRange.new(start_time, finish_time)
      end

      if start_time_of_day || finish_time_of_day
        @time_of_day = TimeOfDayRange.new(start_time_of_day, finish_time_of_day)
      end

      if months
        @months = MonthRange.new(months)
      end

      if weeks_of_month
        @weeks_of_month = WeeksOfMonthRange.new(weeks_of_month)
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
      timestamp = TimeUtil.parse(timestamp)
      return false if @time_range && !@time_range.cover?(timestamp)

      ranges = [@months, @weekdays, @days, @time_of_day, @weeks_of_month].compact
      return false if ranges.empty?

      ranges.all? { |range| range.cover?(timestamp) }
    end

    # Returns schedule represented as a matrix
    # @param start_date [Date, String]
    # @param finish_date [Date, String]
    # @return [Array<Array<Boolean>>]
    def to_matrix(start_date:, finish_date:, resolution: :hour)
      start_time = TimeUtil.parse(start_date).to_time
      finish_time = TimeUtil.parse(finish_date).to_time
      slots = resolution == :hour ? 24 : 24 * 60
      matrix = SlotMatrix.new(slots)

      # TODO: This is needlessly inefficient..
      time_range = TimeRange.new(start_time, finish_time)
      time_range.each(resolution: resolution) do |time|
        matrix << cover?(time)
      end

      matrix.data
    end
  end
end
