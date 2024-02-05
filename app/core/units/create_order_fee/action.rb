# frozen_string_literal: true

module Units
  module CreateOrderFee
    class Action

      def initialize(order:)
        @order = order
      end

      def call
        if can_create?
          Fee.create(owner: order, amount:, percentage:)
        else
          order.fee
        end
      end

      private

      attr_reader :order

      def percentage
        @percentage ||= FindOrderFee::EntryPoint.call(order:)
      end

      def amount
        order.amount * percentage
      end

      def order_fee
        @order_fee ||= order.fee
      end

      def can_create?
        order_fee.nil?
      end

    end
  end
end
