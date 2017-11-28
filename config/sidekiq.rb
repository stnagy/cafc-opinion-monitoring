Sidekiq.configure_server do |config|
  config.redis = { :url => "redis://#{ENV['DATA_REDIS_HOST']}:6379" }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => "redis://#{ENV['DATA_REDIS_HOST']}:6379" }
end