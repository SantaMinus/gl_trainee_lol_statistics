class AddIsFinishedToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :is_finished, :boolean
  end
end
