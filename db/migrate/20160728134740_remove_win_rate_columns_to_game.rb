class RemoveWinRateColumnsToGame < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :team1_winrate, :decimal
    remove_column :games, :team2_winrate, :decimal
  end
end
