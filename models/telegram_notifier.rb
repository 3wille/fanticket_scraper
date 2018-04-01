# frozen_string_literal: true
require "telegram/bot"
require "active_record"
require_relative "telegram_subscription"
require "dotenv/load"

class TelegramNotifier
  BOT_API_TOKEN = ENV["BOT_API_TOKEN"].freeze

  def new_ticket(ticket)
    TelegramSubscription.all.each do |chat|
      send_message(chat_id: chat.chat_id, text: ticket_text(ticket))
    end
  end

  def new_match(match)
    TelegramSubscription.all.each do |chat|
      send_message(chat_id: chat.chat_id, text: match_text(match))
    end
  end

  def get_me
    Telegram::Bot::Client.run(
      BOT_API_TOKEN,
      logger: Logger.new($stdout)
    ) do |bot|
      logger_level = ENV["LOGGER_LEVEL"] || :info
      logger = Logger.new(STDOUT, level: logger_level)
      logger.info bot.api.get_me
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
