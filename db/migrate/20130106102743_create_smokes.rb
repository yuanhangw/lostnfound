class CreateSmokes < ActiveRecord::Migration
  def change
    create_table :smokes do |t|
      t.integer :user_id
      t.integer :wolf_id
      t.integer :parent_user_id
      t.string  :url_token

      t.timestamps
    end

    add_index :smokes, :user_id
    add_index :smokes, :wolf_id
    add_index :smokes, :parent_user_id
    add_index :smokes, [:user_id, :wolf_id], :unique => true
    add_index :smokes, :url_token, :unique => true
  end
end
