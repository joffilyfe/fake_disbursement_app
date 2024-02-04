# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursement do
  it { is_expected.to have_many(:orders) }
  it { is_expected.to belong_to(:merchant) }
end
