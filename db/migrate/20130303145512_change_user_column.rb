class ChangeUserColumn < ActiveRecord::Migration
  def change
      change_column :wolves, :content, :text, :limit => nil
  end

end
