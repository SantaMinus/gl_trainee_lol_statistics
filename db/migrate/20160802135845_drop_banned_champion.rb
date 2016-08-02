class DropBannedChampion < ActiveRecord::Migration[5.0]
  def change
    drop_table :banned_champions
  end
end
