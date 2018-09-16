# frozen_string_literal: true

require 'set'

module Blackcal
  # Time of day range
  class TimeOfDayRange
    # Initialize time of day range
    def initialize(start, finish = nil)
      @start = start
      @finish = finish

      @disallowed_hours = nil
    end

    # Returns true if it covers timestamp
    # @return [Boolean]
    def cover?(timestamp)
      hour = timestamp.hour
      # min = timestamp.min # TODO: Support minutes
      disallowed_hours.include?(hour)
    end

    # Return start hour
    # @return [Integer]
    def start
      @start || 0
    end

    # Return finish hour
    # @return [Integer]
    def finish
      @finish || 0
    end

    # Returns a set with hours that aren't allowed
    # @return [Set<Integer>]
    def disallowed_hours
      @disallowed_hours ||= begin
        array = if @start.nil? && @finish.nil?
                  []
                elsif finish < start
                  (start..23).to_a + (0..finish).to_a
                else
                  (start..finish).to_a
                end

        Set.new(array)
      end
    end
  end
end
