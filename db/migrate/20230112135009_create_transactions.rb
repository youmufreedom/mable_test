class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.references :payer, null: false
      t.references :payee, null: false
      t.timestamps
    end
    add_foreign_key :transactions, :accounts, column: :payer_id
    add_foreign_key :transactions, :accounts, column: :payee_id
  end
end
