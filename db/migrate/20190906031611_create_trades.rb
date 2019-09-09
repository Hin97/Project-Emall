class CreateTrades < ActiveRecord::Migration[5.1]
  def change
    create_table :trades do |t|
      t.integer :user_id
      t.integer :buyquantity
      t.float :totalprice
      t.string :paymethod
      t.boolean :status, :default => false
      t.references :item, foreign_key: true
      

      t.timestamps
    end
      add_index :trades, [:item_id, :created_at]
  end
end
