# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Units::FindOrderFee::EntryPoint do
  subject { described_class.call(order:) }

  context 'when order amount is less than 50 units of money' do
    let(:order) { create(:order, amount: 10.to_money) }

    it { is_expected.to eq(0.01) }
  end

  context 'when order amount is between 50 and 300 units of money' do
    let(:order) { create(:order, amount: 51.to_money) }

    it { is_expected.to eq(0.0095) }

    context 'when it is equal to 300' do
      let(:order) { create(:order, amount: 300.to_money) }

      it { is_expected.to eq(0.0095) }
    end
  end

  context 'when order amount is greater than 300 units' do
    let(:order) { create(:order, amount: 500.to_money) }

    it { is_expected.to eq(0.0085) }
  end
end
