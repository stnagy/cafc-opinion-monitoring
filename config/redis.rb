# $redis = Redis.new(:host => ENV['DATA_REDIS_HOST'], :port => 6379)
# redis = Redis.new(:host => ENV['DATA_REDIS_HOST'], :port => 6379)
# REDIS = Redis.new(:host => ENV['DATA_REDIS_HOST'], :port => 6379)

uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)