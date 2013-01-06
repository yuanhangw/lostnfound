class CreateWolves < ActiveRecord::Migration
  def change
    create_table :wolves do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :wolves, [:user_id, :created_at]
  end
end
