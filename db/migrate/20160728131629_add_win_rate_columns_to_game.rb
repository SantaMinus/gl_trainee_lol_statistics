class AddWinRateColumnsToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :team1_winrate, :decimal
    add_column :games, :team2_winrate, :decimal
  end
end
