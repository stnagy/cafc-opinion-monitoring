class Search < ApplicationRecord
	
	belongs_to :user
	has_many :search_results, dependent: :destroy
	has_many :litigations, through: :search_results
	
	def get_results
		
		# initialize params to put into ransack search
		params = {}
		params[:number_cont] = number if number
		params[:origin_cont] = origin if origin
		params[:name_cont] = name if name
		params[:precedential_cont] = precedential if precedential
		params[:opinion_text_cont] = opinion_text if opinion_text
		
		# do ransack search and make associations	
		results = Litigation.ransack(params).result
		results.each do |result|
			self.search_results.where(search_id: self.id, litigation_id: result.id).first_or_create
		end
		
		# return results for use when needed (e.g. controller)
		return results
	end

end
