# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    uuid { SecureRandom.uuid }
    reference { 'company_name' }
    disbursement_frequency { 'DAILY' }
    minimum_monthly_fee_cents { 0.05.to_money.cents }
    live_on { '2024-02-04' }
    email { 'company@mail.com' }
  end
end
