class CafcOpinionWorker < Sidekiq::Worker
	include Sidekiq::Worker
  sidekiq_options :queue => :high
  
	def perform
		Litigation.get_cafc_opinions
	end
end