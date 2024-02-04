# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant do
  let(:merchant) { build(:merchant) }

  it { is_expected.to have_many(:orders) }
  it { expect(merchant.email).to eq('company@mail.com') }
  it { expect(merchant.minimum_monthly_fee).to eq(0.05.to_money) }
  it { expect(merchant.minimum_monthly_fee.format).to eq('€0.05') }
end
