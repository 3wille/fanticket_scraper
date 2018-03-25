# frozen_string_literal: true
class Match < ActiveRecord::Base
  has_many :tickets
end
