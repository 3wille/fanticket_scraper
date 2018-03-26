# frozen_string_literal: true
require "telegram/bot"
require "active_record"
require_relative "telegram_chat"

class TelegramNotifier
  BOT_API_TOKEN = ENV["BOT_API_TOKEN"].freeze

  def notify(ticket)
    TelegramChat.all.each do |chat|
      send_message(chat_id: chat.chat_id, text: text(ticket))
    end
  end

  private

  def text(ticket)
    "New Ticket:\n
    Opponent: #{ticket.opponent}\n
    Seat: #{ticket.seat_description}\n
    Link: #{ticket.match.tickets_url}"
  end

  def send_message(chat_id:, text:)
    Telegram::Bot::Client.run(BOT_API_TOKEN) do |bot|
      bot.api.send_message(chat_id: chat_id, text: text)
    end
  end
end
