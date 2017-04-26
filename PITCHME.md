---

# Notification Engine
#### a Ruby on Rails Gem

---

## The Problem

- Something happens and peeps need to know 'bout it.
- Some things are important (SMS please!)
- Others are just FYIs (email is fine)
- Peeps have preferences (no SMS please!)
- And peeps speak different languages

---

So, we need a way to easily create and send notifications to peeps across many different mediums and languages.

---

## Example

Notify team members when a new member has been added.

---

## 1. Install

```ruby
gem 'notification_engine'
```

```
bundle
```

---

## 2. Add medium

```
rails g medium Email
```

---

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

---

## 3. Add notification

```
rails g notification NewTeamMember
```

+++

```ruby
class NewTeamMemberNotification < NotificationEngine::Notification
  def mediums
    [:email]
  end

  def data
    {
      email: 'ned@example.com',
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

---

## 4. Write Notification Template

config/locales/en.yml:

```yml
en:
  notifications:
    new-team-member-notification:
      email:
        subject: '{{ new_user.name }} was just created'
        body: >
          Hi {{ recipient.name }},
          A new user named {{ new_user.name }} was added to your team. Please login to review the new user.
```

---

## 5. Wire up callback to send notifications

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