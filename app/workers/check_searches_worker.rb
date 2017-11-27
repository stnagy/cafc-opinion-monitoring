class CheckSearchesWorker < Sidekiq::Worker
	include Sidekiq::Worker
  sidekiq_options :queue => :high

	def perform(user_id)
		User.find(user_id).check_for_search_results
	end

end