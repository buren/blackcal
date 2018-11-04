# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Blackcal::ArrayUtil do
  describe '::deep_flatten' do
    # input, expected
    [
      [1, [1]],
      [[1], [1]],
      [[1..2, 4, 9..10, 11],  [1, 2, 4, 9, 10, 11]],
      [[Struct.new(:to_a).new([1, 2]), 4],  [1, 2, 4]],
    ].each do |data|
      input, expected = data

      it 'returns correct array' do
        expect(described_class.flatten(input)).to eq(expected)
      end
    end
  end
end
