#!/usr/bin/env ruby
# frozen_string_literal: true

class ProcessingRequest
  require 'faraday'
  require 'json'
  require 'digest'
  require 'constants'
  require 'dotenv/load'

  PUBLIC_KEY = ENV['PUBLIC_KEY']
  PRIVATE_KEY = ENV['PRIVATE_KEY']

  class ResponseDataError < StandardError; end
  class CharacterNotFound < StandardError; end
  class ConnectionError < StandardError; end

  def initialize(names)
    @names = names
  end

  def self.call(...)
    new(...).call
  end

  def call
    @names.map { |name| process_request(make_url(name), name) }
  end

  private

  def make_url(name)
    ts = Time.now.to_i
    hash = Digest::MD5.hexdigest(ts.to_s + PRIVATE_KEY + PUBLIC_KEY)
    "#{HOST}#{name}&ts=#{ts}&apikey=#{PUBLIC_KEY}&hash=#{hash}"
  end

  def process_request(url, character)
    # также без begin/end
    response = Faraday.get(url)
    process_data(response.body, character)
    # ловим конкретно ошибку Faraday
  rescue Faraday::Error => e
    # рейзим кастомные ошибки, и только их потом перехватываем.
    raise ConnectionError, "Sorry, connection to Marvel database failed, reason: #{e.message}"
  end

  def process_data(data, character)
    parsed_data = JSON.parse(data, symbolize_names: true)[:data]
    if parsed_data.nil?
      raise ResponseDataError, "Sorry, there is no data in response from Marvel db. #{data} is returned"
    end

    result = parsed_data.fetch(:results)
    raise CharacterNotFound, "Sorry. Character <<#{character}>> is not found! Choose another", [] if result.empty?

    result.first.slice(:name, :description)
  end
end
