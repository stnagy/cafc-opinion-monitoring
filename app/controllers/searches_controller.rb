class SearchesController < ApplicationController

	before_action :authenticate_user!
	
	def index
		# load searches and litigations that match the searches
		@searches = current_user.searches.includes(:litigations).order(:status_date => 'desc')
		@search = Search.new
		puts "searches!"
	end
	
	def create
		search = current_user.searches.create(search_params)
		redirect_to searches_path
	end
	
	def update
		@search = current_user.searches.find(params[:search][:id])
		@search.update(params[:search])
	end
	
	def destroy
		search = current_user.searches.find(params[:id]).destroy
		redirect_to searches_path
	end
	
	private
	
	def search_params
		params.require(:search).permit(:name, :number)
	end
	
end
