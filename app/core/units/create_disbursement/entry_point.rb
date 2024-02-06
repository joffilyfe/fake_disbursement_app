# frozen_string_literal: true

module Units
  module CreateDisbursement
    class EntryPoint

      include Units::EntryPoint

      def initialize(merchant:, orders_starts_from:, orders_ends_at:, created_at: Time.zone.now)
        @action = Action.new(merchant:, orders_starts_from:, orders_ends_at:, created_at:)
      end

    end
  end
end
