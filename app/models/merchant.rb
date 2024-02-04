# frozen_string_literal: true

class Merchant < ApplicationRecord

  monetize :minimum_monthly_fee_cents

end
