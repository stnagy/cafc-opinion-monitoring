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
		
		raise update_ransack_code
		results = Ransack.search()
		
		results.each do |result|
			raise make_the_search_result_association_with_user
			# if new result, send email to user
		end
	end

end
