class NewUserNotification < NotificationEngine::Notification
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
