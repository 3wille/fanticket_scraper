#!/usr/bin/env ruby
# frozen_string_literal: true

require "nokogiri"
require "open-uri"
require "active_support/all"
require "active_record"
require "pry"
require_relative "models"
require "dotenv/load"

def main
  $host = "https://www.fcstpauli-ticketboerse.de"

  while true do
    begin
      doc = Nokogiri::HTML(open("#{$host}/fansale/"))
      create_matches(doc)
      matches = Match.all
      create_tickets(matches)
      sleep 10
    rescue => e
      puts e
    end
  end
end

def create_matches(doc)
  match_entries = doc.css("a.SportEventEntry")
  match_entries.each do |entry|
    build_match(entry)
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

def build_match(match_div)
  tickets_url = match_div["href"]
  opponent = match_div.css(".SportEventEntry-VersusHeadlineGuestTeam").text.strip
  Match.find_or_create_by(
    opponent: opponent, tickets_url: tickets_url
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

# Change the following to reflect your database settings
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/development.sqlite3",
  pool: 5,
  timeout: 5000,
)

main
