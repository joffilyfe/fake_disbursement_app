# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisbursementOrder do
  it { is_expected.to belong_to(:order) }
  it { is_expected.to belong_to(:disbursement) }
end
