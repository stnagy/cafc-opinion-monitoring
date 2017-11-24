class CheckSearchesWorker < Sidekiq::Worker
	queue :high

	def perform(user_id)
		User.find(user_id).check_for_search_results
	end

end