class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.bigint :account_number, null: false, index: { unique: true }
      t.decimal :balance, precision: 8, scale: 2, null: false, default: 0.00

      t.timestamps
    end
  end
end
