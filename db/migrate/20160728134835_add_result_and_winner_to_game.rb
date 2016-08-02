class AddResultAndWinnerToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :result, :decimal
    add_column :games, :winner, :integer
  end
end
