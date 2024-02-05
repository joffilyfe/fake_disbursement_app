# frozen_string_literal: true

module Units
  module FindOrderFee
    class Action

      def initialize(order:)
        @order = order
      end

      def call
        FEES.select { |fee| fee.call(order) }&.first&.call(order)
      end

      private

      attr_reader :order

      Fee = Struct.new(:value, :minimum?)

      FEES = [
        ->(order) { 0.01 if order.amount < 50.to_money },
        ->(order) { 0.0095 if order.amount >= 50.to_money && order.amount <= 300.to_money },
        ->(order) { 0.0085 if order.amount > 300.to_money }
      ].freeze

    end
  end
end
