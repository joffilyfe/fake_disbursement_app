# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    external_id { 'e653f3e14bc4' }
    association :merchant
    amount { 100.to_money }
    created_at { Time.zone.today }
    disbursed { false }

    trait :disbursed do
      disbursed_at { Time.zone.today }
      disbursed { true }
    end
  end
end
