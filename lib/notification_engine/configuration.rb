module NotificationEngine
  class Configuration
    attr_accessor :default_mediums

    def initialize
      @default_mediums = []
    end
  end
end