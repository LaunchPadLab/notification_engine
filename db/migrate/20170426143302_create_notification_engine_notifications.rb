class CreateNotificationEngineNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notification_engine_notifications do |t|
      t.string   "type"
      t.boolean  "is_read", default: false
      t.boolean  "is_sent", default: false
      t.string   "notifiable_type"
      t.integer  "notifiable_id"
      t.string   "recipient_type"
      t.integer  "recipient_id"
      t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id", using: :btree
      t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient_type_and_recipient_id", using: :btree

      t.timestamps
    end
  end
end
