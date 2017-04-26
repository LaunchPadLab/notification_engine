module NotificationEngine
  class Notification < ApplicationRecord
    # e.g. a user
    belongs_to :recipient, polymorphic: true

    # e.g. the object that triggered the notification
    belongs_to :notifiable, polymorphic: true

    validates_presence_of :type

    def mediums
      # defaults to no mediums,
      # but can be overridden in each subclass
      # e.g. [:email, :sms]
      NotificationEngine.configuration.default_mediums || []
    end

    def data
      # hook for subclasses
      # hash passed to the medium and liquid template
      # with data used by the notification
      {}
    end

    def deliver
      mediums.each do |medium|
        medium.deliver if medium.active?
      end
      mark_as_sent
    end

    def mark_as_sent
      update_columns(is_sent: true)
    end

    def slug
      self.class.name.underscore.dasherize
    end

    private

    def medium_objects
      @medium_objects ||= mediums.map do |medium|
        medium_class = "Mediums::#{medium.to_s.classify}Medium".constantize
        medium_class.new(localization_path, data)
      end
    end

    def localization_path
      "notifications.#{slug}"
    end
  end
end
