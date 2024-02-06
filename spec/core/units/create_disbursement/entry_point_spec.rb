# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Units::CreateDisbursement::EntryPoint do
  subject { described_class.call(merchant:, orders_starts_from:, orders_ends_at:, created_at:) }

  let(:merchant) { create(:merchant) }
  let(:orders_starts_from) { Time.zone.today - 1.day }
  let(:orders_ends_at) { Time.zone.today - 1.day }
  let(:created_at) { nil }

  before { Timecop.freeze }

  context 'when there is no order to disburse' do
    it { expect { subject }.not_to change(Disbursement, :count) }

    context 'when there is an order but out of the range given' do
      let(:order) { create(:order, amount: 100.to_money, merchant:, created_at: orders_starts_from - 1.day) }

      it { expect { subject }.not_to change(Disbursement, :count) }
    end
  end

  context 'when there are orders to disburse on the current day' do
    let(:order) { create(:order, amount: 100.to_money, merchant:, created_at: orders_starts_from) }

    before { order }

    it { expect { subject }.to change(Disbursement, :count).by(1) }
    it { expect { subject }.to change(Fee, :count).by(1) }

    describe 'disburse orders' do
      it { expect { subject && order.reload }.to change(order, :disbursed).from(false).to(true) }
      it { expect { subject && order.reload }.to change(order, :disbursed_at).from(nil).to(Time.zone.today) }
    end

    context 'when calculating its amounts' do
      before { create(:order, amount: 10.to_money, merchant:, created_at: orders_starts_from) }

      it 'sets gross amount from orders amounts sum' do
        subject

        expect(Disbursement.first.gross_amount).to eq(110.to_money)
      end

      it 'sets fee amount from orders fees amounts sum' do
        subject

        expect(Disbursement.first.fee_amount).to eq(Fee.all.sum(&:amount))
      end

      it 'sets net amount from orders gross amount minus orders fees amounts sum' do
        subject

        gross = Order.all.sum(&:amount)
        fee = Fee.all.sum(&:amount)

        expect(Disbursement.first.net_amount).to eq(gross - fee)
      end
    end
  end
end
