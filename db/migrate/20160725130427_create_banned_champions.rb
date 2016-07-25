class CreateBannedChampions < ActiveRecord::Migration[5.0]
  def change
    create_table :banned_champions do |t|
      t.integer :champion_id
      t.integer :team_id
      t.integer :pick_turn

      t.timestamps
    end
  end
end
