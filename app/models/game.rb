class Game < ApplicationRecord
  has_many :banned_champions 
  has_many :participants
end
