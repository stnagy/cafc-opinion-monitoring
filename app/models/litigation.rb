class Litigation < ApplicationRecord
	
	has_many :search_results
	has_many :searches, through: :search_results
	has_many :users, through: :searches
	
end
