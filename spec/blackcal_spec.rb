# frozen_string_literal: true

RSpec.describe Blackcal do
  it 'has a version number' do
    expect(Blackcal::VERSION).not_to be nil
  end

  describe '::schedule' do
    it 'returns a Schedule' do
      expect(described_class.schedule).to be_a(Blackcal::Schedule)
    end

    it 'yields to builder if block given' do
      schedule = Blackcal.schedule { months :january }

      expect(schedule.months.to_a).to eq([:january])
    end
  end
end
