class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, # :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :searches, dependent: :destroy
  has_many :search_results, through: :searches
  has_many :litigations, through: :search_results
  
	def check_for_search_results
		searches = self.searches
		
		searches.each do |search|
			search.get_results
		end
	end

end
