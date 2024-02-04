# frozen_string_literal: true

class Order < ApplicationRecord

  monetize :amount_cents

  belongs_to :merchant, primary_key: :reference, foreign_key: :merchant_reference, inverse_of: false

end
