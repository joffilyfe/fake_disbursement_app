class CreateFees < ActiveRecord::Migration[7.0]
  def change
    create_table :fees do |t|
      t.monetize :amount, null: false
      t.decimal  :percentage, null: false
      t.references :owner, polymorphic: true, null: false

      t.timestamps
    end
  end
end
