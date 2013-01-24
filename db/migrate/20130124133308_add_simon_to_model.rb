class AddSimonToModel < ActiveRecord::Migration
  def change
    # change user
    add_column :users, :idstr, :string
    # added to hack around a sqlite bug
    change_column :users, :idstr, :string, :null => false

    add_index  :users, :idstr, :unique => true
    #remove_column :users, :remeber_token
 
    # change shoots
    create_table :shoots do |t|
      t.integer :user_id
      t.integer :smoke_id
      t.string  :content
      t.timestamps
    end
    add_index :shoots, :user_id
    add_index :shoots, :smoke_id
    add_index :shoots, [:user_id, :smoke_id]

    # change praises
    create_table :praises do |t|
      t.integer :user_id
      t.integer :shoot_id
      t.string  :content

      t.timestamps
    end
    add_index :praises, :user_id
    add_index :praises, :shoot_id
    add_index :praises, [:user_id, :shoot_id], :unique => true

    # change smokes
    add_column :smokes, :user_idstr_chain, :text
    # added to hack around a sqlite bug
    change_column :smokes, :user_idstr_chain, :text, :null => false
    add_index :smokes, :user_idstr_chain, :length => 1000
    add_index :smokes, [:wolf_id, :user_idstr_chain], :unique= => true, :length => {:user_idstr_chain => 1000 }

   end
end
