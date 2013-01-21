class AddParentToSmokes < ActiveRecord::Migration
  def change

  	add_column :smokes, :parent_id, :integer
    add_index :smokes, :parent_id
  end
end
