require 'rubygems'
require 'clockwork'
require 'sidekiq'
require './config/boot'
require './config/environment'                                      

Sidekiq.configure_server do |config|
  config.redis = { :url => "redis://#{ENV['DATA_REDIS_HOST']}:6379" }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => "redis://#{ENV['DATA_REDIS_HOST']}:6379" }
end

# control scheduled jobs like a boss

module Clockwork
  
  every 1.day, "Update CAFC Opinions", :at => ['10:45', '10:50', '10:55', '11:00', '11:01', '11:02', '11:03', '11:04', '11:05', '11:10', '11:15'], :tz => "Eastern Time (US & Canada)" do
  	CafcOpinionWorker.perform_async
  end 
  
  every 1.hour, "Update CAFC Opinions" do 
		CafcOpinionWorker.perform_async
	end

end