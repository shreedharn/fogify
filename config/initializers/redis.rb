redisUrl = ENV['REDISTOGO_URL']
unless redisUrl.nil?
  uri = URI.parse(redisUrl)
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  $redis = Redis.new
end
