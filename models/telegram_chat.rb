# frozen_string_literal: true

class TelegramChat < ActiveRecord::Base
  validates :chat_id, uniqueness: true
end
