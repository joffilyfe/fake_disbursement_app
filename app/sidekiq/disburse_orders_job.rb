# frozen_string_literal: true

class DisburseOrdersJob

  include Sidekiq::Job

  def perform
    Merchant.all.filter_map do |merchant|
      next unless merchant.disburse_today?

      Units::CreateDisbursement::EntryPoint.call(merchant:, **params(merchant:))
    end
  end

  private

  def params(merchant:)
    if merchant.disburse_daily?
      { orders_starts_from: Time.zone.today, orders_ends_at: Time.zone.now, created_at: Time.zone.today }
    else
      { orders_starts_from: Time.zone.today.weeks_ago(1), orders_ends_at: Time.zone.now,
        created_at: Time.zone.today }
    end
  end

end
