NotificationEngine.configure do |config|
  # e.g. ['email']
  # key should correspond with slug of medium
  config.default_mediums = [:email]
end
