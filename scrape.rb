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
entries = doc.css("a.SportEventEntry")
matches = []
entries.each do |entry|
  tickets_url = entry["href"]
  opponent = entry.css(".SportEventEntry-VersusHeadlineGuestTeam").text.strip
  matches << Match.new(opponent: opponent, tickets_url: tickets_url)
end

matches.each do |match|

end
puts matches
