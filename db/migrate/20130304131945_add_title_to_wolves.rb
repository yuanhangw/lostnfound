class AddTitleToWolves < ActiveRecord::Migration
  def change
  	add_column :wolves, :title, :string
  end
end
