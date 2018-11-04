# frozen_string_literal: true

require 'blackcal/array_util'

module Blackcal
  # Day range
  class DayRange
    include Enumerable

    # @return [Array<Integer>] numbers in range
    attr_reader :numbers

    # Initialize numbers range
    # @param [Array<#to_a>, Array<Integer>, Integer, nil] numbers
    # @example
    #   DayRange.new(1)
    # @example
    #   DayRange.new([1, 2])
    # @example
    #   DayRange.new([9..10, 13..14])
    def initialize(numbers)
      @numbers = ArrayUtil.flatten(numbers) if numbers
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
