class Player < ApplicationRecord
	validates_presence_of :name, :region
	
	API_KEY = "RGAPI-A8BBED3E-9609-429F-8E00-E6941CA18891".freeze
end
