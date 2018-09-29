# frozen_string_literal: true
class Match < ActiveRecord::Base
  validate :eventim_id, :uniqueness
  has_many :tickets, dependent: :destroy
end
