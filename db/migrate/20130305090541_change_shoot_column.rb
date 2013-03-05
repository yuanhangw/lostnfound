class ChangeShootColumn < ActiveRecord::Migration
  def change
      change_column :shoots, :content, :text
  end

end
