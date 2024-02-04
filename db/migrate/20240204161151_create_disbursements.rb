class CreateDisbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :disbursements do |t|
      t.string :reference, null: false, limit: 32
      t.references :merchant, null: false, foreign_key: true
      t.monetize :gross_amount, null: false
      t.monetize :net_amount, null: false
      t.monetize :fee_amount, null: false
      t.monetize :fee_minimum_amount, null: false

      t.timestamps
    end

    add_index :disbursements, :reference
    add_index :disbursements, :fee_minimum_amount_cents
  end
end
