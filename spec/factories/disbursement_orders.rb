# frozen_string_literal: true

FactoryBot.define do
  factory :disbursement_order do
    association :disbursement
    association :order
  end
end
