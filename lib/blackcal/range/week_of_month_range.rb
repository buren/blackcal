# frozen_string_literal: true

require 'blackcal/time_util'
require 'blackcal/array_util'

module Blackcal
  # Week of month range
  class WeekOfMonthRange
    include Enumerable

    # @return [Array<Integer>] numbers in range
    attr_reader :numbers

    # Initialize numbers range
    # @param [Array<Integer>, Integer, nil] numbers
    # @example
    #   WeekOfMonthRange.new(1)
    # @example
    #   WeekOfMonthRange.new([1, 2])
    def initialize(numbers)
      @numbers = ArrayUtil.flatten(numbers) if numbers
    end

    # Returns true if it covers timestamp
    # @return [Boolean]
    def cover?(timestamp)
      return false if numbers.nil? || numbers.empty?

      numbers.include?(TimeUtil.week_of_month(timestamp))
    end

    # @return [Array<Integer>] numbers in range
    alias_method :to_a, :numbers

    # Iterate over range
    # @see #to_a
    def each(&block)
      to_a.each(&block)
    end
  end
end
