module NotificationEngine
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc "Creates a NotificationEngine initializer in your application."

      def copy_initializer
        copy_file "initializer.rb", "config/initializers/notification_engine.rb"
      end
    end
  end
end
