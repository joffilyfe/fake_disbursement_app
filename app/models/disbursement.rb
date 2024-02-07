# frozen_string_literal: true

class Disbursement < ApplicationRecord

  monetize :gross_amount_cents
  monetize :net_amount_cents
  monetize :fee_amount_cents
  monetize :fee_minimum_amount_cents

  belongs_to :merchant

  has_many :disbursement_orders, dependent: nil
  has_many :orders, through: :disbursement_orders
  has_one :fee, as: :owner, dependent: nil

end
