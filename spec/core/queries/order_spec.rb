# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Order do
  let(:merchant) { create(:merchant) }
  let(:order) { create(:order, merchant:, created_at: Time.zone.today) }
  let(:starts) { Time.zone.today - 2.days }
  let(:ends) { Time.zone.today }

  it { expect(described_class.by_created_at_range(merchant:, starts:, ends:)).to eq([order]) }

  context 'when the range starts and ends at the same day' do
    let(:starts) { Time.zone.today }
    let(:ends) { Time.zone.today }

    it { expect(described_class.by_created_at_range(merchant:, starts:, ends:)).to eq([order]) }
  end

  context 'when there is no order for the merchant' do
    let(:order) { create(:order, created_at: Time.zone.today) }

    it { expect(described_class.by_created_at_range(merchant:, starts:, ends:)).to eq([]) }
  end

  context 'when there is no order for the given range' do
    let(:starts) { Time.zone.today - 5.days }
    let(:ends) { Time.zone.today - 4.days }

    it { expect(described_class.by_created_at_range(merchant:, starts:, ends:)).to eq([]) }
  end
end
