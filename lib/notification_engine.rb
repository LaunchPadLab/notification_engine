require 'notification_engine/engine'
require 'notification_engine/configuration'
require 'liquid'

module NotificationEngine
  def self.configure(&block)
    block.call(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end
end

require 'notification_engine/mediums/base'