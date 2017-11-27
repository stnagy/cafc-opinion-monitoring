class SearchResult < ApplicationRecord
	
	belongs_to :search
	belongs_to :litigation
	
	has_one :user, through: :search

	after_create :send_email_to_user
	
	def send_email_to_user
		# raise error_need_to_implement_email
	end
	
end
