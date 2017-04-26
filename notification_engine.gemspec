$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "notification_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "notification_engine"
  s.version     = NotificationEngine::VERSION
  s.authors     = ["Ryan Francis"]
  s.email       = ["ryan.p.francis@gmail.com"]
  s.homepage    = "https://github.com/launchpadlab/notification_engine"
  s.summary     = "Simple notification engine for sending messages across multiple delivery mediums (sms, email, etc.)"
  s.description = "A notification engine for Rails devs"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0", ">= 5.0.0.1"
  s.add_dependency "liquid"

  s.add_development_dependency "sqlite3"
end
