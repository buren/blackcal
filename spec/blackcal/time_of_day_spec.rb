# frozen_string_literal: true

require 'spec_helper'
require 'time'

RSpec.describe Blackcal::TimeOfDay do
  describe '<=>' do
    it 'returns true with greater than or equal' do
      t1 = described_class.new(14, 59)
      t2 = described_class.new(14, 59)

      expect(t1 >= t2).to eq(true)
    end

    it 'returns true when equal' do
      t1 = described_class.new(14, 59)
      t2 = described_class.new(14, 59)

      expect(t1 == t2).to eq(true)
    end

    context 'can compare with integer' do
      it do
        expect(described_class.new(13) > 10).to eq(true)
      end

      it do
        expect(described_class.new(10) < 11).to eq(true)
      end

      it do
        expect(described_class.new(10) == 10).to eq(true)
      end
    end

    [
      # expected, t1_hour, t1_min, t2_hour, t2_min
      [true, 14, 0, 13, 0],
      [true, 14, 1, 14, 0],
      [true, 16, 0, 14, 1],
      [true, 16, 59, 16, 58],
      [false, 14, 1, 14, 1],
      [false, 14, 0, 14, 1],
      [false, 9, 0, 14, 49],
    ].each do |data|
      expected, t1_hour, t1_min, t2_hour, t2_min = data

      it "returns #{expected} for #{t1_hour}:#{t1_min} > #{t2_hour}:#{t2_min}" do
        t1 = described_class.new(t1_hour, t1_min)
        t2 = described_class.new(t2_hour, t2_min)

        expect(t1 > t2).to eq(expected)
      end
    end
  end
end
