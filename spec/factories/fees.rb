# frozen_string_literal: true

FactoryBot.define do
  factory :fee do
    amount { 10.to_money }
    percentage { 0.0095 }
    association :owner, factory: :order
  end

  trait :order do
    association :owner, factory: :order
  end
end
