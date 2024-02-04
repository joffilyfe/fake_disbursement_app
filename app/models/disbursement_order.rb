# frozen_string_literal: true

class DisbursementOrder < ApplicationRecord

  belongs_to :disbursement
  belongs_to :order

end
