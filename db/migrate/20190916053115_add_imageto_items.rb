class AddImagetoItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :image, :string
  end
end
