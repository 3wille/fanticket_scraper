# frozen_string_literal: true
require "telegram/bot"
require "active_record"
require_relative "models/telegram_chat"

class TelegramRegistration
  BOT_API_TOKEN = ENV["BOT_API_TOKEN"]

  def register
    Telegram::Bot::Client.run(BOT_API_TOKEN) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          if created = TelegramChat.create(chat_id: message.chat.id)
            bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
          else
            bot.api.send_message(chat_id: message.chat.id, text: "Start failed, error:\n#{created}")
          end
        when '/stop'
          chat = TelegramChat.find_by(chat_id: message.chat.id)
          deleted = chat.delete
          if deleted
            bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
          else
            bot.api.send_message(chat_id: message.chat.id, text: "Stop failed, error:\n#{deleted}")
          end
        end
      end
    end
  end
end

# Change the following to reflect your database settings
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/development.sqlite3",
  pool: 5,
  timeout: 5000,
)
TelegramRegistration.new.register
