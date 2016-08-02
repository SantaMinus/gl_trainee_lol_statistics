class FixColumnName < ActiveRecord::Migration[5.0]
  def change
  	rename_column :players, :current_game_id, :game_id
  end
end
