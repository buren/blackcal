# frozen_string_literal: true

module Blackcal
  # Time range
  class TimeRange
    include Enumerable

    attr_reader :start, :finish

    # Initialize time range
    # @param [Time, nil] start_time
    # @param [Time, nil] finish_time optional
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

    # Returns range as array
    # @param resolution [Symbol] :hour our :min
    # @return [Array<Array<Integer>>] times
    def to_a(resolution: :hour)
      resolution_multiplier = resolution == :hour ? 60 * 60 : 60
      time_units = ((start - finish) / resolution_multiplier).abs.to_i

      time_units.times.map do |time_unit|
        start + (time_unit * resolution_multiplier)
      end
    end

    # Iterate over range
    # @param resolution [Symbol] :hour our :min
    def each(resolution: :hour, &block)
      to_a(resolution: resolution).each(&block)
    end
  end
end
