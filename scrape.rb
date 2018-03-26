#!/usr/bin/env ruby
# frozen_string_literal: true

require "nokogiri"
require "open-uri"
require "active_support/all"
require "active_record"
require "pry"
require_relative "models"

def main
  $host = "https://www.fcstpauli-ticketboerse.de"
  binding.pry

  doc = Nokogiri::HTML(open("#{$host}/fansale/"))
  matches = build_matches(doc)
  build_tickets(matches)
end

def build_matches(doc)
  match_entries = doc.css("a.SportEventEntry")
  matches = []
  match_entries.each do |entry|
    tickets_url = entry["href"]
    opponent = entry.css(".SportEventEntry-VersusHeadlineGuestTeam").text.strip
    matches << Match.find_or_create_by(
      opponent: opponent, tickets_url: tickets_url
    ) do |match|
      TelegramNotifier.new.new_match(match)
    end
  end
  matches
end

def build_tickets(matches)
  matches.each do |match|
    match_doc = Nokogiri::HTML(open("#{$host}/#{match.tickets_url}"))
    offer_list = match_doc.css(".EventEntryList")
    offer_list.children.each do |offer_div|
      build_ticket(offer_div)
    end
  end
end

def build_ticket(offer_div)
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
  TelegramNotifier.new.notify(ticket)
end

# Change the following to reflect your database settings
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/development.sqlite3",
  pool: 5,
  timeout: 5000,
)

main
