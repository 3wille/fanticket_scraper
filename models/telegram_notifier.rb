# frozen_string_literal: true
require "telegram/bot"
require "active_record"
require_relative "telegram_chat"

class TelegramNotifier
  BOT_API_TOKEN = ENV["BOT_API_TOKEN"].freeze

  def new_ticket(ticket)
    TelegramChat.all.each do |chat|
      send_message(chat_id: chat.chat_id, text: ticket_text(ticket))
    end
  end

  def new_match(match)
    TelegramChat.all.each do |chat|
      send_message(chat_id: chat.chat_id, text: match_text(match))
    end
  end

  private

  def ticket_text(ticket)
    "*New Ticket*\n"\
    "Opponent: #{ticket.opponent}\n"\
    "Seat: #{ticket.seat_description}\n"\
    "Link: #{full_ticket_url(ticket.match.tickets_url)}"
  end

  def full_ticket_url(ticket_url)
    "#{$host}#{ticket_url}"
  end

  def match_text(match)
    "New Match: #{match.opponent}"
  end

  def send_message(chat_id:, text:)
    Telegram::Bot::Client.run(BOT_API_TOKEN) do |bot|
      bot.api.send_message(chat_id: chat_id, text: text, parse_mode: "Markdown")
    end
  end
end
