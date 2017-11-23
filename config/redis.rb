$redis = Redis.new(:host => ENV['DATA_REDIS_HOST'], :port => 6379)
redis = Redis.new(:host => ENV['DATA_REDIS_HOST'], :port => 6379)
REDIS = Redis.new(:host => ENV['DATA_REDIS_HOST'], :port => 6379)
