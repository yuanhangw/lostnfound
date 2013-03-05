class ChangeUserColumn < ActiveRecord::Migration

	def up
	    change_column :wolves, :content, :text
	end
	def down
	    change_column :wolves, :content, :string
	end

end
