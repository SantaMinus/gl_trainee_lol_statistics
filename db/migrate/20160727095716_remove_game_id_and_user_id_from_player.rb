class RemoveGameIdAndUserIdFromPlayer < ActiveRecord::Migration[5.0]
  def change
    remove_column :players, :game_id, :integer
    remove_column :players, :users_id, :integer
  end
end
