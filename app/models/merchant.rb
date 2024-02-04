# frozen_string_literal: true

class Merchant < ApplicationRecord

  monetize :minimum_monthly_fee_cents

  has_many :orders, foreign_key: :merchant_reference, primary_key: :reference, dependent: :destroy, inverse_of: false

end
