class ApplicationController < ActionController::Base
	protect_from_forgery prepend: true, with: :exception
	skip_before_action :verify_authenticity_token, if: -> { controller_name == "sessions" && action_name == "create" || "destroy" }
	
	def after_sign_in_path_for(resource)
	  searches_path
	end
end
