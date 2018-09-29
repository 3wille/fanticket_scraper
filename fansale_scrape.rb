#!/usr/bin/env ruby
# frozen_string_literal: true

require "nokogiri"
require "open-uri"
require "active_support/all"
require "active_record"
require "pry"
require_relative "models"
require "dotenv/load"
require "raven/base"

def main
  $host = "https://www.eventimsports.de/"
  logger_level = ENV["LOGGER_LEVEL"] || :info
  $logger = Logger.new(STDOUT, level: logger_level)
  base_url = "https://api.eventim.com/seatmap/api/availability/TIXX/1001"

  while true do
    begin
      Raven.capture do
        $logger.info "Starting a new scraping run"
        doc = Nokogiri::HTML(open("#{$host}/ols/fcstpauli/de/hs/channel/shop/index/"))
        create_matches(doc)
        matches = Match.all
        url = "#{base_url}/"
        binding.pry
        create_tickets(matches)
      end
    rescue => e
      puts e
    ensure
      sleep 10
    end
  end
end

def create_matches(doc)
  match_entries = doc.css(".card.event-card")
  match_entries.each do |entry|
    create_match(entry)
  end
end

def create_tickets(matches)
  matches.each do |match|
    match_doc = Nokogiri::HTML(open("#{$host}/#{match.tickets_url}"))
    offer_list = match_doc.css(".EventEntryList")
    offer_list.children.each do |offer_div|
      build_ticket(offer_div, match)
    end
  end
end

def create_match(match_div)
  eventim_id = match_div["data-event-id"]
  opponent = match_div.css(".event-card__heading--away").text.strip
  tickets_url = match_div.css("a.button").first["href"]
  Match.create_with(tickets_url: tickets_url).find_or_create_by(
    opponent: opponent, eventim_id: eventim_id,
  ) do |match|
    TelegramNotifier.new.new_match(match)
  end
end

def build_ticket(offer_div, match)
  eventim_id = offer_div.attr("data-offer-id")
  unless eventim_id.nil?
    prices = offer_div.attr("data-ticket-prices")
    seat_description = offer_div.css(".OfferEntry-SeatDescription").first.text
    Ticket.find_or_create_by(eventim_id: eventim_id) do |new_ticket|
      new_ticket.prices = prices
      new_ticket.seat_description = seat_description
      new_ticket.match = match
      notify(new_ticket)
    end
  end
end

def notify(ticket)
  TelegramNotifier.new.new_ticket(ticket)
end

Raven.configure do |config|
  config.dsn = 'https://edd3b9e6098a434c979c3b244b5714b6:ebec75a3b9414adbb9d0200257bdd2e9@sentry.io/866849'
end

# Change the following to reflect your database settings
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/development.sqlite3",
  pool: 5,
  timeout: 5000,
)
TelegramNotifier.new.get_me
main
