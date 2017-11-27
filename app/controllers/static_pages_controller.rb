class StaticPagesController < ApplicationController

	def index
		@opinions = Litigation.where(status: 'opinion').order(:status_date => 'asc').first(20)
		@arguments = Litigation.where(status: 'argument').order(:status_date => 'asc').first(20)
		render 'static/home'
	end

end
