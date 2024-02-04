# frozen_string_literal: true

class ProcessOrdersJob

  include Sidekiq::Job

  def perform(orders)
    ActiveRecord::Base.transaction do
      orders = orders.map { |data| order(data) }
      Order.insert_all(orders) unless orders.empty?
    end
  end

  private

  def order(data)
    external_id, reference, amount, date = data.split(';')

    {
      external_id:,
      merchant_reference: reference,
      amount_cents: Money.from_amount(amount.to_f).cents,
      created_at: date,
      updated_at: date
    }
  end

end
