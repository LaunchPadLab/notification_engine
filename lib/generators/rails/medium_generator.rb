module Rails
  module Generators
    class MediumGenerator < NamedBase
      source_root File.expand_path('../templates', __FILE__)
      check_class_collision :suffix => 'Medium'

      class_option :parent, :type => :string, :desc => 'The parent class for the generated medium'

      def create_medium_file
        template 'medium.rb.erb', File.join('app/notification_engine/mediums', class_path, "#{file_name}_medium.rb")
      end

      private

      def parent_class_name
        'NotificationEngine::Mediums::Base'
      end

      def slug
        class_name.downcase
      end
    end
  end
end
