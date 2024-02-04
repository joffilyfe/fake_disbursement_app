class CreateDisbursementOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :disbursement_orders do |t|
      t.references :disbursement, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end

    add_index :disbursement_orders, :order_id, unique: true, name: 'disbursement_orders_order_id_unique'
  end
end
