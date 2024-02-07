# frozen_string_literal: true

class Merchant < ApplicationRecord

  monetize :minimum_monthly_fee_cents

  has_many :orders, foreign_key: :merchant_reference, primary_key: :reference, dependent: :destroy, inverse_of: false
  has_many :disbursements, dependent: nil

  def disburse_daily?
    disbursement_frequency.to_sym == :DAILY
  end

  def disburse_weekly?
    disbursement_frequency.to_sym == :WEEKLY
  end

  def disburse_today?(date = nil)
    disburse_daily? || (disburse_weekly? && live_on.wday == Time.zone.today.wday) \
      || (date && disburse_weekly? && live_on.wday == date.wday)
  end

end
