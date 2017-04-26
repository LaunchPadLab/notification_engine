module Mediums
  class EmailMedium < NotificationEngine::Mediums::Base
    attr_reader :email, :subject, :body

    def after_init(args = {})
      @email = args[:email]
      @subject = args.fetch(:subject, parse_template(:subject))
      @body = args.fetch(:body, parse_template(:body))
    end

    def deliver
      # NotificationMailer.basic_notification(message_args).deliver_later
    end

    def slug
      'email'
    end

    private

    def required_attrs
      [:email]
    end

    def message_args
      @message_args ||= {
        to: email,
        subject: subject,
        body: body
      }
    end
  end
end
