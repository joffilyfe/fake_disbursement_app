# frozen_string_literal: true

FactoryBot.define do
  factory :disbursement do
    merchant { nil }
    disbursement_count { 1 }
    amount { '' }
    fee_amount { '' }
    fee_minimum_count { 1 }
    fee_minimum_amount { '' }
  end
end
