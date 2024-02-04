# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order do
  let(:order) { build(:order) }

  it { is_expected.to belong_to(:merchant) }
  it { is_expected.to have_one(:disbursement) }
  it { expect(order.amount).to eq(100.to_money) }
  it { expect(order.amount.format).to eq('€100.00') }
end
