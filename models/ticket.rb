# frozen_string_literal: true

class Ticket < ActiveRecord::Base
  belongs_to :match

  delegate :opponent, to: :match
end
