class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.references :trade, foreign_key: true
      t.string :username
      t.string :email
      t.text :notification_params
      t.string :status
      t.datetime :purchased_at
      t.string :transaction_id
      t.timestamps
    end
      add_index :payments, [:trade_id, :created_at]
  end
end
