require 'postmark'

class SearchResult < ApplicationRecord
	
	belongs_to :search
	belongs_to :litigation
	
	has_one :user, through: :search

	after_create :send_email_to_user
	
	def send_email_to_user
		litigation = self.litigation
		return if litigation.status_date < Time.now - 7.days

		user = self.user

		client = Postmark::ApiClient.new('c7cf71e3-11fe-4820-8aa2-8ebba852e709')
		client.deliver(
		  from: 'info@76analytics.com',
		  to: user.email,
		  subject: "CAFC Opinion - #{litigation.name} (No. #{litigation.number})",
		  html_body: "<h1>Opinion: <a href='#{litigation.url}'>#{litigation.name}</a> (No. #{litigation.number}).<h1>",
		  track_opens: true)
	end
	
end
