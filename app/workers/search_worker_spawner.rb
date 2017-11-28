class SearchWorkerSpawner
	include Sidekiq::Worker
  sidekiq_options :queue => :high
	
	def perform
		User.all.each { |user| CheckSearchesWorker.perform_async(user.id) }
	end

end