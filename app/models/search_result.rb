class SearchResult < ApplicationRecord
	
	belongs_to :search
	belongs_to :litigation
	
	has_one :user, through: :search

	after_create :send_email_to_user
	
	def send_email_to_user
		UpdateMailer.new_cafc_opinion(self.user.id, self.litigation.id).deliver_now
	end
	
end
