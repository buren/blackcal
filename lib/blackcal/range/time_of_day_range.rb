# frozen_string_literal: true

module Blackcal
  # Time of day range
  class TimeOfDayRange
    # Initialize time of day range
    def initialize(start, finish = nil)
      @start = start || 0
      @finish = finish || 0

      @disallowed_hours = if @finish < @start
                            (@start..23).to_a + (0..@finish).to_a
                          else
                            (@start..@finish).to_a
                          end
    end

    # Returns true if it covers timestamp
    # @return [Boolean]
    def cover?(timestamp)
      hour = timestamp.hour
      # min = timestamp.min # TODO: Support minutes
      @disallowed_hours.include?(hour)
    end
  end
end
