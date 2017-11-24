class CafcOpinionWorker < Sidekiq::Worker
	queue :high

	def perform
		Litigation.get_cafc_opinions
	end
end