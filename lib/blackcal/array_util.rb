# frozen_string_literal: true

module Blackcal
  # Time utils module
  module ArrayUtil
    # @param [Array, Array<#to_a>, Object] data
    # @return [Array]
    def self.flatten(data)
      Array(data).map do |object|
        next object.to_a if object.respond_to?(:to_a)
        object
      end.flatten(1)
    end
  end
end
