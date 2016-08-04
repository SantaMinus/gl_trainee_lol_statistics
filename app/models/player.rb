class Player < ApplicationRecord
  API_KEY = 'RGAPI-A8BBED3E-9609-429F-8E00-E6941CA18891'.freeze
  REGIONS = [['Russia', "ru"], ['EU Nordic & East', 'eun'], ['EU West', 'euw'], ['North America', 'na'], ['Latin America North', 'la1'], ['Latin America South', 'la2'], ['Brazil', 'br'], ['Japan', 'jp'], ['Turkey', 'tr'], ["Oceania", 'oc'], ['Republic of Korea', 'kr']]

  validates :name, presence: true

  has_many :participants
  has_many :games, :through => :participants
end
