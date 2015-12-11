Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
  config.host = ENV['AIRBRAKE_HOST']
  config.environment_name = ENV['AIRBRAKE_ENVIRONMENT_NAME']
  config.port = ENV['AIRBRAKE_PORT'].to_i
  config.secure = config.port == 443
end
