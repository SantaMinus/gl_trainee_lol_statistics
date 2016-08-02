class Player < ApplicationRecord
  API_KEY = 'RGAPI-A8BBED3E-9609-429F-8E00-E6941CA18891'.freeze

  validates :name, presence: true

  has_many :participants
  has_many :games, :through => :participants
end
