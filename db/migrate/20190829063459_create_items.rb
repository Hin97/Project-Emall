class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.float :price
      t.text :description
      t.integer :quantity
      t.references :user, foreign_key: true

      t.timestamps
    end
      add_index :items, [:user_id, :created_at]
  end
end
