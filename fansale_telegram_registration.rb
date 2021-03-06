#!/usr/bin/env ruby
# frozen_string_literal: true
require "telegram/bot"
require "active_record"
require_relative "models/telegram_subscription"
require "dotenv/load"
require "pry"
require "raven/base"

class TelegramRegistration
  BOT_API_TOKEN = ENV["BOT_API_TOKEN"].freeze

  def register
    puts "Starting Telegram Bot"
    Telegram::Bot::Client.run(BOT_API_TOKEN) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          start_message(bot, message)
        when '/stop'
          stop_message(bot, message)
        end
      end
    end
  end

  private

  def start_message(bot, message)
    if created = TelegramSubscription.create(chat_id: message.chat.id, first_name: message.from.first_name)
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
      puts "New Subscriber: #{message.chat.id}"
    else
      bot.api.send_message(chat_id: message.chat.id, text: "Start failed, error:\n#{created}")
      puts "Subscription failed: #{created}"
    end
  end

  def stop_message(bot, message)
    chat = TelegramSubscription.find_by(chat_id: message.chat.id)
    deleted = chat&.destroy
    if deleted
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    else
      bot.api.send_message(chat_id: message.chat.id, text: "Stop failed, error:\n#{deleted}")
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
Raven.configure do |config|
  config.dsn = 'https://edd3b9e6098a434c979c3b244b5714b6:ebec75a3b9414adbb9d0200257bdd2e9@sentry.io/866849'
end
Raven.capture do
  TelegramRegistration.new.register
end
