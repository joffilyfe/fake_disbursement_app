# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Units::CreateDisbursement::EntryPoint do
  subject { described_class.call(merchant:, orders_starts_from:, orders_ends_at:) }

  let(:merchant) { create(:merchant, minimum_monthly_fee: 3000.to_money) }
  let(:orders_starts_from) { Time.zone.today.beginning_of_day - 1.day }
  let(:orders_ends_at) { Time.zone.today.end_of_day - 1.day }

  before { Timecop.freeze('2024-01-10') }

  context 'when there is no order to disburse at the given range' do
    it { expect { subject }.not_to change(Disbursement, :count) }

    context 'when there is an order but out of the range given' do
      let(:order) { create(:order, amount: 100.to_money, merchant:, created_at: orders_starts_from - 1.day) }

      it { expect { subject }.not_to change(Disbursement, :count) }
    end
  end

  context 'when there are orders to disburse on the current day' do
    let(:order) { create(:order, amount: 100.to_money, merchant:, created_at: orders_starts_from) }
    let(:first_month_disbursement) { create(:disbursement, merchant:, fee_amount: 10.to_money) }

    before do
      order
      first_month_disbursement
    end

    it { expect { subject }.to change(Disbursement, :count).by(1) }
    it { expect { subject }.to change(Fee, :count).by(1) }

    describe 'disburse orders' do
      it { expect { subject && order.reload }.to change(order, :disbursed).from(false).to(true) }
      it { expect { subject && order.reload }.to change(order, :disbursed_at).from(nil).to(Time.zone.today) }
    end

    context 'when calculating disbursements amounts' do
      before { create(:order, amount: 10.to_money, merchant:, created_at: orders_starts_from) }

      it 'sets gross amount from orders amounts sum' do
        expect(subject.gross_amount).to eq(110.to_money)
      end

      it 'sets fee amount from orders fees amounts sum' do
        expect(subject.fee_amount).to eq(Fee.all.sum(&:amount))
      end

      it 'sets net amount from orders gross amount minus orders fees amounts sum' do
        subject

        gross = Order.all.sum(&:amount)
        fee = Order.all.map(&:fee).sum(&:amount)

        expect(Disbursement.where(merchant:).last.net_amount).to eq(gross - fee)
      end
    end
  end

  context 'when it is the first disbursement of the month' do
    context 'when the minimum_monthly_fee was not met for the last month' do
      let(:order) { create(:order, amount: 100.to_money, merchant:, created_at: orders_starts_from) }

      before do
        order
        create(:disbursement, merchant:, fee_amount: 10.to_money, created_at: Time.zone.today.months_ago(1))
      end

      it { expect { subject }.to change(Fee, :count).by(2) }
    end
  end
end
