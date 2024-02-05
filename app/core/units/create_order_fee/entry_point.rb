# frozen_string_literal: true

module Units
  module CreateOrderFee
    class EntryPoint

      include Units::EntryPoint

      def initialize(order:)
        @action = Action.new(order:)
      end

    end
  end
end
