# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Units::CreateOrderFee::EntryPoint do
  subject { described_class.call(order:) }

  let(:percentage) { Units::FindOrderFee::EntryPoint.call(order:) }
  let(:order) { create(:order, amount: 100.to_money) }
  let(:expected_fee_amount) { percentage * order.amount }
  let(:expected_fee_percentage) { percentage }

  it { expect { subject }.to change(Fee, :count).by(1) }
  it { expect(subject.amount).to eq(expected_fee_amount) }
  it { expect(subject.percentage).to eq(expected_fee_percentage) }

  context 'when order does have a fee already' do
    before { create(:fee, owner: order) }

    it { expect { subject }.not_to change(Fee, :count) }
  end
end
