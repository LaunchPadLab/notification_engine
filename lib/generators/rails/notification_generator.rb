module Rails
  module Generators
    class NotificationGenerator < NamedBase
      source_root File.expand_path('../templates', __FILE__)
      check_class_collision :suffix => 'Notification'

      class_option :parent, :type => :string, :desc => 'The parent class for the generated notification'

      def create_notification_file
        template 'notification.rb.erb', File.join('app/models', class_path, "#{file_name}_notification.rb")
      end

      private

      def parent_class_name
        'NotificationEngine::Notification'
      end
    end
  end
end
