class SearchesController < ApplicationController

	before_action :authenticate_user!
	
	def index
		# load searches and litigations that match the searches
		@searches = current_user.searches.includes(:litigations).order(:created_at => 'asc')
	end
	
	def show
		@search = current_user.searches.find(params[:search][:id])
		@results = @search.get_results.order(:created_at => 'asc').first(50)
	end
	
	def new
		@search = Search.new
	end
	
	def update
		@search = current_user.searches.find(params[:search][:id])
		@search.update(params[:search])
		redirect_to 'show'
	end
	
	def destroy
		search = current_user.searches.find(params[:search][:id]).destroy
		redirecto_to 'index'
	end
	
	private
	
end
