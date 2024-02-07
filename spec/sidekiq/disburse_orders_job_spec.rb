# frozen_string_literal: true

require 'rails_helper'
RSpec.describe DisburseOrdersJob, type: :job do
  before { Timecop.freeze('2024-01-10') }

  it { expect { described_class.perform_async }.to change(described_class.jobs, :size).by(1) }

  context 'when there is no order to disburse' do
    it { expect { described_class.new.perform }.not_to change(Fee, :count) }
    it { expect { described_class.new.perform }.not_to change(Disbursement, :count) }
  end

  context 'when there is order to disburse' do
    let(:merchant) { create(:merchant, minimum_monthly_fee_cents: 0) }
    let(:order) { create(:order, merchant:) }
    let(:orders_ends_at) { Time.zone.now }
    let(:orders_starts_from) { Time.zone.today }

    before { order }

    it { expect { described_class.new.perform }.to change(Fee, :count).by(1) }
    it { expect { described_class.new.perform }.to change(Disbursement, :count).by(1) }

    it 'calls CreateDisbursement using correct params' do
      expect(Units::CreateDisbursement::EntryPoint).to receive(:call).with(
        merchant:, orders_ends_at:, orders_starts_from:, created_at: Time.zone.today
      )

      described_class.new.perform
    end
  end
end
