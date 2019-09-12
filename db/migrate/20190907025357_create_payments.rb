class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.string :cardname 
      t.string :cardnumber 
      t.integer :expmm 
      t.integer :expyy 
      t.integer :cvv 
      t.references :trade, foreign_key: true
      
      t.timestamps
    end
      add_index :payments, [:trade_id, :created_at]
  end
end
