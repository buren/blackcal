# frozen_string_literal: true

module Blackcal
  # Represents a time of day (hour and min)
  class TimeOfDay
    include Comparable

    # @return [Integer] hour
    attr_reader :hour

    # @return [Integer] minutes defaults to 0
    attr_reader :min

    # Initialize time of day
    # @param [Integer] hour
    # @param [Integer, nil] min optional argument
    def initialize(hour, min = nil)
      @hour = hour
      @min = min || 0
    end

    # Compares two time of days
    # @param [TimeOfDay, Integer] other if a number is passed it will be used as the hour
    # @return [Integer] 1 if greater than, 0 if equal, -1 if less than
    def <=>(other)
      seconds <=> TimeUtil.time_of_day(other).seconds
    end

    # Returns the number of seconds since midnight
    # @return [Number] seconds since midnight
    def seconds
      (hour * 60 * 60) + (min * 60)
    end
  end
end
