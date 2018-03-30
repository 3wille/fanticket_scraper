class CreateTelegramSubscription < ActiveRecord::Migration[5.1]
  def change
    create_table :telegram_chats do |t|
      t.integer :chat_id
      t.timestamps
    end
  end
end
