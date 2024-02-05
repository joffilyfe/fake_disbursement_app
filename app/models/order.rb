# frozen_string_literal: true

class Order < ApplicationRecord

  monetize :amount_cents

  belongs_to :merchant, primary_key: :reference, foreign_key: :merchant_reference, inverse_of: false
  has_one :disbursement_order, dependent: nil
  has_one :disbursement, through: :disbursement_order
  has_one :fee, as: :owner, dependent: nil

end
