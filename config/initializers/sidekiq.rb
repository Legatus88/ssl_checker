require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { host: Settings.redis.host, port: Settings.redis.port, db: Settings.sidekiq.redis.db, id: nil }
end

Sidekiq.configure_server do |config|
  config.redis = { host: Settings.redis.host, port: Settings.redis.port, db: Settings.sidekiq.redis.db, id: nil }
end

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == Settings.sidekiq.web.username && password == Settings.sidekiq.web.password
end
