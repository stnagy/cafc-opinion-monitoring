class SearchResult < ApplicationRecord
	
	belongs_to :search
	belongs_to :litigation
	
	has_one :user, through: :search
	
end
