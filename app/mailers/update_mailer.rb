class UpdateMailer < ApplicationMailer

	default from: 'notifications@example.com'
	
	def new_cafc_opinion(user_id, litigation_id)
		@user = User.find(user_id)
		@litigation = @user.litigations.find(litigation_id)
		@url = root_url
		mail(to: @user.email, subject: "New CAFC Opinion Alert")
	end

end
