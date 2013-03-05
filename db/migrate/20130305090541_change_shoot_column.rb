class ChangeShootColumn < ActiveRecord::Migration
  def change
      change_column :shoots, :content, :text, :limit => nil
  end

end
