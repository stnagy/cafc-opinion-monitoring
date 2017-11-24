class Search < ApplicationRecord
	
	belongs_to :user
	has_many :search_results, dependent: :destroy
	has_many :litigations, through: :search_results
	
end
