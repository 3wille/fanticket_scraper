class RenameTelegramSubscription < ActiveRecord::Migration[5.1]
  def change
    rename_table("telegram_chats", "telegram_subscriptions")
  end
end
