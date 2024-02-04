class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :external_id, null: false
      t.string :merchant_reference, null: false
      t.monetize :amount
      t.boolean :disbursed, null: false, default: false
      t.date :disbursed_at

      t.timestamps
    end

    add_foreign_key :orders, :merchants, column: :merchant_reference, primary_key: :reference
    add_index :orders, :created_at
    add_index :orders, :disbursed
    add_index :orders, :disbursed_at
  end
end
