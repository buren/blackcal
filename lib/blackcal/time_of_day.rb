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
      other_seconds = if other.is_a?(self.class)
                        (other.hour * 60 * 60) + (other.min * 60)
                      else
                        other * 60 * 60
                      end
      seconds = (hour * 60 * 60) + (min * 60)

      seconds <=> other_seconds
    end
  end
end