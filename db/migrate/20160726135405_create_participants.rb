class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.integer :player_id
      t.integer :game_id
    end
  end
end
