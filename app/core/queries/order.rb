# frozen_string_literal: true

module Queries
  class Order

    class << self

      def by_created_at_range(merchant:, starts:, ends:)
        ::Order.where(merchant:, created_at: starts..ends)
      end

      def undisbursed(merchant:, starts:, ends:)
        by_created_at_range(merchant:, starts:, ends:).where(disbursed: false)
      end

    end

  end
end
