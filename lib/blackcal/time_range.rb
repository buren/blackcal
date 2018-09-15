# frozen_string_literal: true

module Blackcal
  # Time range
  class TimeRange
    attr_reader :start, :finish

    # Initialize time range
    def initialize(start_time, finish_time = nil)
      @start = start_time
      @finish = finish_time
    end

    # Returns true if it covers timestamp
    # @return [Boolean]
    def cover?(timestamp)
      return false if start.nil? && finish.nil?
      return start < timestamp if finish.nil?
      return finish > timestamp if start.nil?

      return true if finish < timestamp
      return true if start > timestamp

      false
    end
  end
end
