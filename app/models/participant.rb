class Participant < ApplicationRecord
  validates_presence_of :player_id, :game_id

  belongs_to :game
  belongs_to :player
end
