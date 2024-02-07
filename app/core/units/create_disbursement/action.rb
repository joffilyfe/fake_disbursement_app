# frozen_string_literal: true

module Units
  module CreateDisbursement
    class Action

      def initialize(merchant:, orders_starts_from:, orders_ends_at:, created_at:)
        @merchant = merchant
        @orders_starts_from = orders_starts_from
        @orders_ends_at = orders_ends_at
        @created_at = created_at
      end

      def call
        return unless orders.any?

        ActiveRecord::Base.transaction do
          disbursement
          disburse_orders
          disbursement
        end
      end

      private

      attr_reader :merchant, :orders_starts_from, :orders_ends_at, :created_at

      def disbursement
        @disbursement ||= Disbursement.create(disbursement_attrs)
      end

      def disbursement_attrs
        { reference: SecureRandom.hex,
          merchant:,
          fee_amount:,
          gross_amount:,
          net_amount:,
          orders:,
          fee:,
          fee_minimum_amount:,
          created_at: }
      end

      def orders
        @orders ||= Queries::Order.undisbursed(merchant:, starts: orders_starts_from, ends: orders_ends_at)
      end

      def fee_amount
        @fee_amount ||= orders.map do |order|
          CreateOrderFee::EntryPoint.call(order:)
        end.sum(&:amount)
      end

      def gross_amount
        orders.sum(&:amount)
      end

      def net_amount
        gross_amount - fee_amount
      end

      def disburse_orders
        orders.update_all(disbursed: true, disbursed_at: Time.zone.today)
      end

      def fee
        Subactions::CreateMinimumMonthlyFee.new(merchant:).call
      end

      def fee_minimum_amount
        fee&.amount&.to_money
      end

    end
  end
end
