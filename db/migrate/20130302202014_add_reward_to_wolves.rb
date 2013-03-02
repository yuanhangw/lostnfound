class AddRewardToWolves < ActiveRecord::Migration
  def change
  	add_column :wolves, :reward, :string
  end
end
