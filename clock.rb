require 'clockwork'
require 'sidekiq'                                   
require_relative "config/boot"
require_relative "config/environment"

Sidekiq.configure_server do |config|
  config.redis = { :url => ENV['REDISTOGO_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => ENV['REDISTOGO_URL'] }
end

# control scheduled jobs like a boss

module Clockwork
  
  every 1.day, "Update CAFC Opinions", :at => ['10:45', '10:50', '10:55', '11:00', '11:01', '11:02', '11:03', '11:04', '11:05', '11:10', '11:15'], :tz => "Eastern Time (US & Canada)" do
  	CafcOpinionWorker.perform_async
  end 
  
  every 1.day, "Search for Alert Matches", :at => ['10:46', '10:51', '10:56', '11:01', '11:02', '11:03', '11:04', '11:05', '11:06', '11:11', '11:16'], :tz => "Eastern Time (US & Canada)" do
  	SearchWorkerSpawner.perform_async
  end 

  
  every 1.hour, "Update CAFC Opinions", :at => '**:05' do 
		CafcOpinionWorker.perform_async
	end
	
	every 1.hour, "Search for Alert Matches", :at => '**:06' do 
		SearchWorkerSpawner.perform_async
	end


end