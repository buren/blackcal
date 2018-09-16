# frozen_string_literal: true

module Blackcal
  # Slot matrix
  class SlotMatrix
    # Initialize slot matrix
    # @param [Integer] slots max elements in each slot
    def initialize(slots)
      @matrix = [[]]
      @slots = slots
    end

    # @return [Array<Array<Object>>] data
    def data
      @matrix
    end

    # Add value
    # @param [Object, nil] value
    def <<(value)
      array = @matrix[@matrix.length - 1] || []

      # move to next slot when max slot length is reached
      if array.length >= @slots
        array = []
        @matrix << array
      end

      array << value
    end
  end
end
