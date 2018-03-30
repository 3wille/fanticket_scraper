# frozen_string_literal: true

class TelegramSubscription < ActiveRecord::Base
  validates :chat_id, uniqueness: true
end
