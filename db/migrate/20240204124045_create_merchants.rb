# frozen_string_literal: true

class CreateMerchants < ActiveRecord::Migration[7.0]
  def change
    create_table :merchants do |t|
      t.uuid :uuid, null: false
      t.string :reference, null: false
      t.string :disbursement_frequency
      t.monetize :minimum_monthly_fee
      t.date :live_on
      t.string :email

      t.timestamps
    end

    add_index :merchants, :reference, unique: true
  end
end
