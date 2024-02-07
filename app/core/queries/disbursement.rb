# frozen_string_literal: true

module Queries
  class Disbursement

    class << self

      def last_month_by_merchant(merchant:)
        last_month = Time.zone.now.months_ago(1)

        ::Disbursement.where(merchant:, created_at: last_month.all_month)
      end

      def current_month_by_merchant(merchant:)
        ::Disbursement.where(merchant:, created_at: Time.zone.today.all_month)
      end

    end

  end
end
