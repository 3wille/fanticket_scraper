#!/usr/bin/env ruby
# frozen_string_literal: true

require "nokogiri"
require "open-uri"
require "activesupport"

class Match
  attr_accessor :opponent, :tickets
  def initialize(opponent:, tickets_url:)
    @opponent = opponent
    @tickets = tickets
    @tickets_url = tickets_url
  end
end

class Ticket
  def initialize(id:, count:, price:, seat:)
    @id = id
    @count = count
    @price = price
    @seat = seat
  end
end

host = "https://www.fcstpauli-ticketboerse.de"

doc = Nokogiri::HTML(open("#{host}/fansale/"))
matches = build_matches(doc)

matches.each do |match|
  match_doc = Nokogiri::HTML(open("#{host}/#{match.tickets_url}"))
  offer_list = match_doc.css("EventEntryList")
  offer_list.each do |offer|

  end
end
puts matches

def build_matches(doc)
  match_entries = doc.css("a.SportEventEntry")
  matches = []
  match_entries.each do |entry|
    tickets_url = entry["href"]
    opponent = entry.css(".SportEventEntry-VersusHeadlineGuestTeam").text.strip
    matches << Match.new(opponent: opponent, tickets_url: tickets_url)
  end
  matches
end
