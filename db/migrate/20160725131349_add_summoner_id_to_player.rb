class AddSummonerIdToPlayer < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :summoner_id, :integer
  end
end
