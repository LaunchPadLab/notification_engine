# NotificationEngine Overview

Flexibly create notifications that can be sent across multiple mediums, like email, SMS, and push.

## Overview

There are two types of objects: `Notification` and `Medium`

`Notification` is a parent class for different types of notifications. For example, a subclass may be: CalendarEventChangeNotification which is created for every user that is notified of a calendar event change.

`Mediums::Base` is a parent class for different types of communication mediums. For example, email, SMS, or push.

## Usage

There are four steps to wire up a notification:

1. Add Medium(s)
2. Add Notification
3. Write notification template for each medium
4. Wire up callback to send notifications

### 1. Creating Mediums

```
rails g medium Email
rails g medium Sms
```

After making some changes to the generated file to suit our needs, we end up with something like the following:

```ruby
module Mediums
  class EmailMedium < NotificationEngine::Mediums::Base
    attr_reader :email, :subject, :body

    def after_init(args = {})
      @email = args[:email]
      @subject = args.fetch(:subject, parse_template(:subject))
      @body = args.fetch(:body, parse_template(:body))
    end

    def deliver
      NotificationMailer.basic_notification(message_args).deliver_later
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
```

```ruby
module Mediums
  class SmsMedium < NotificationEngine::Mediums::Base
    attr_reader :body, :mobile_phone

    def after_init(args = {})
      @mobile_phone = args[:mobile_phone]
      @body = args.fetch(:body, parse_template(:body))
    end

    def deliver
      # hook up Twilio or other SMS service here
      # we can pass in mobile_phone and body as args
    end

    def slug
      'sms'
    end

    private

    def required_attrs
      [:mobile_phone]
    end
  end
end
```

The only two required methods for a `Medium` are `slug` and `deliver`. You'll see why the slug is important here in a bit.

### 2. Creating a Notification

```
rails g notification NewTeamMember
```

```ruby
class NewTeamMemberNotification < NotificationEngine::Notification
  def mediums
    [:email, :sms]
  end

  def data
    {
      email: 'ned@example.com',
      mobile_phone: '123-456-1828',
      recipient: {
        name: 'Ned Stark'
      },
      new_user: {
        name: 'Jon Snow'
      }
    }
  end
end
```

In this case, `email` is used by the `email` medium and `mobile_phone` is used by `sms` medium. The other information in `data` will be used by our template.

### 3. Write Template

In config/locales/en.yml:

```yml
en:
  notifications:
    new-team-member-notification:
      email:
        subject: '{{ new_user.name }} was just created'
        body: >
          Hi {{ recipient.name }},
          A new user named {{ new_user.name }} was added to your team. Please login to review the new user.
    another-example-notification:
      all:
        body: An example body that would work across all mediums for this notification
```

### 4. Wire up callback to send notifications

```ruby
class User < ApplicationRecord
  after_create :send_notifications

  def send_notifications
    team_members.each do |team_member|
      notification = NewTeamMemberNotification.create(
        recipient: team_member,
        notifiable: self
      )
      notification.deliver
    end
  end
end
```

## Installation

Gemfile:

```ruby
gem 'notification_engine'
```

```
bundle
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
