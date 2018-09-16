# frozen_string_literal: true

module Blackcal
  # Number range
  class DayRange
    include Enumerable

    # @return [Array<Integer>] numbers in range
    attr_reader :numbers

    # Initialize numbers range
    # @param [Array<Integer>, Integer, nil] numbers
    # @example
    #   NumberRange.new(1)
    # @example
    #   NumberRange.new([1, 2])
    def initialize(numbers)
      @numbers = Array(numbers) if numbers
    end

    # Returns true if it covers timestamp
    # @return [Boolean]
    def cover?(timestamp)
      return false if numbers.nil? || numbers.empty?

      numbers.include?(timestamp.day)
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
