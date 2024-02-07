# frozen_string_literal: true

FactoryBot.define do
  factory :disbursement do
    association :merchant
    reference { SecureRandom.hex }
    gross_amount { 10.to_money }
    fee_amount { 1.to_money }
    net_amount { 9.to_money }
  end
end
