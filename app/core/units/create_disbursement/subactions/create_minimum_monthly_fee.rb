# frozen_string_literal: true

module Units
  module CreateDisbursement
    module Subactions
      class CreateMinimumMonthlyFee

        def initialize(merchant:)
          @merchant = merchant
        end

        def call
          create_minimum_monthly_fee
        end

        private

        attr_reader :merchant

        def last_month_charged_fee
          @last_month_charged_fee ||= Queries::Disbursement.last_month_by_merchant(merchant:).sum(&:fee_amount)
        end

        def create_minimum_fee?
          last_month_charged_fee < merchant.minimum_monthly_fee && first_of_the_month?
        end

        def first_of_the_month?
          Queries::Disbursement.current_month_by_merchant(merchant:).empty?
        end

        def create_minimum_monthly_fee
          return unless create_minimum_fee?

          Fee.new(amount: merchant.minimum_monthly_fee - last_month_charged_fee, percentage: 1)
        end

      end
    end
  end
end
