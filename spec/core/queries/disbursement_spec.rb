# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Disbursement do
  let(:merchant) { create(:merchant) }

  before { Timecop.freeze('2024-01-10') }

  describe '#last_month_by_merchant' do
    context 'when merchant has disbursements last month' do
      let(:disbursement) { create(:disbursement, merchant:, created_at: Time.zone.today.months_ago(1)) }

      before { disbursement }

      it { expect(described_class.last_month_by_merchant(merchant:)).to eq([disbursement]) }
    end

    context 'when merchant has not disbursements last month' do
      it { expect(described_class.last_month_by_merchant(merchant:)).to eq([]) }
    end
  end

  describe '#current_month_by_merchant' do
    context 'when merchant has disbursements this month' do
      let(:disbursement) { create(:disbursement, merchant:, created_at: Time.zone.today) }

      before { disbursement }

      it { expect(described_class.current_month_by_merchant(merchant:)).to eq([disbursement]) }
    end

    context 'when merchant has not disbursements this month' do
      it { expect(described_class.current_month_by_merchant(merchant:)).to eq([]) }
    end
  end
end
