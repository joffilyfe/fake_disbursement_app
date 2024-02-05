# frozen_string_literal: true

class Fee < ApplicationRecord

  monetize :amount_cents

  belongs_to :owner, polymorphic: true

end
