# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Units::CreateDisbursement::Subactions::CreateMinimumMonthlyFee do
  subject { described_class.new(merchant:).call }

  let(:merchant) { create(:merchant, minimum_monthly_fee: minimum_monthly_fee) }
  let(:minimum_monthly_fee) { 3000.to_money }

  before { Timecop.freeze('2024-01-01') }

  context 'when merchant does not have disbursement in the last month' do
    context 'when it is the first disbursement of the month' do
      context 'when difference between it and merchant\'s minimum_monthly_fee is greater than 0' do
        it { expect(subject.class).to eq(Fee) }

        it { expect(subject.amount).to eq(minimum_monthly_fee) }
      end

      context "when difference between it and merchant's minimum_monthly_fee is less or equal to 0" do
        before do
          create(:disbursement, merchant:, fee_amount: minimum_monthly_fee + 10.to_money,
                                created_at: Time.zone.today.months_ago(1))
        end

        it { expect(subject).to be_nil }
      end
    end

    context 'when it is not the first disbursement of the month' do
      before do
        create(:disbursement, merchant:, fee_amount: 0.to_money)
      end

      it { expect(subject).to be_nil }
    end
  end
end
