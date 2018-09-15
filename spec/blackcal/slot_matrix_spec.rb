# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Blackcal::SlotMatrix do
  it 'adds data to slots' do
    matrix = described_class.new(2)
    matrix << 1
    matrix << 1
    matrix << 1

    expect(matrix.data).to eq([[1, 1], [1]])
  end
end
