module NotificationEngine
  module Mediums
    # medium from which to send a message to a recipient
    # there are only two required methods for a subclass of Medium:
    # - deliver
    # - slug
    # one must also implement the templates in the localization file
    # e.g. config/locales/en.yml
    class Base
      attr_reader :localization_path, :data

      def initialize(localization_path, data = {})
        @localization_path = localization_path # e.g. notifications.calendar-event-change
        @data = data
        after_init(data)
        require_attrs
      end

      # START INTERFACE

      # e.g. logic to check recipient's delivery preferences
      # to ensure the user has activated this medium
      def active?
        true
      end

      # delivers message to recipient through medium
      def deliver
        raise "deliver method is required for #{self.class.name}"
      end

      # corresponds with the medium in en.yml
      # e.g. 'email', 'sms', 'push', etc.
      def slug
        raise "slug method is required for #{self.class.name}"
      end

      private

      # hook for subclasses to require data
      def required_attrs
        []
      end

      def after_init(_args = {})
        # hook for subclasses
      end

      # END INTERFACE

      def all_required_attrs
        base_required_attrs + required_attrs
      end

      def base_required_attrs
        %i(localization_path data)
      end

      def require_attrs
        all_required_attrs.each do |attr|
          raise "#{attr} is required for #{self.class.name}" if send(attr).nil?
        end
      end

      # finds the template in en.yml
      # for example, finds the email body for
      # the CalendarChangeNotification
      def find_template(template_name, options = {})
        medium = options.fetch(:medium, slug)
        template_path = "#{localization_path}.#{medium}.#{template_name}"

        if I18n.exists?(template_path, :en)
          template = I18n.t(template_path)
        else
          options_for_all = { medium: :all, original_path: template_path }
          return find_template(template_name, options_for_all) if medium == slug
          raise "template not found: #{options[:original_path]}. Please check en.yml"
        end
        template
      end

      # parses the template in en.yml
      # for example, the email body for the CalendarChangeNotification
      # it passes a data hash to the template to populate the template
      # with data specific to this notification, like the recipient name
      def parse_template(template_name)
        source = find_template(template_name)
        template = Liquid::Template.parse(source, error_mode: :strict)
        template.render(template_data, strict_variables: true)
      end

      def template_data
        data.with_indifferent_access
      end
    end
  end
end