# frozen_string_literal: true

namespace :load_sample_data do
  task run: [:environment]  do
    (Date.parse('2022-01-01')..Date.parse('2023-12-31')).each do |date|
      puts("Processing orders at #{date}")
      Merchant.all.select { |merchant| merchant.disburse_today?(date) }.each do |merchant|
        Units::CreateDisbursement::EntryPoint.call(merchant:, **params(merchant:, starts: date))
      end
    end
  end

  def params(merchant:, starts:)
    if merchant.disburse_daily?
      { orders_starts_from: starts, orders_ends_at: starts.end_of_day, created_at: starts.end_of_day }
    else
      { orders_starts_from: starts.weeks_ago(1), orders_ends_at: starts.end_of_day,
        created_at: starts }
    end
  end
end
