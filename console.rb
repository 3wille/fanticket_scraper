#!/usr/bin/env ruby
# frozen_string_literal: true

require "active_support/all"
require "active_record"
require "pry"
require_relative "models"
require "dotenv/load"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/development.sqlite3",
  pool: 5,
  timeout: 5000,
)

binding.pry
