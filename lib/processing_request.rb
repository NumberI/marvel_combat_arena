#!/usr/bin/env ruby

class ProcessingRequest
  require 'faraday'
  require 'json'
  require 'digest'
  require 'constants'
  require 'dotenv/load'
  
  PUBLIC_KEY = ENV['PUBLIC_KEY']
  PRIVATE_KEY = ENV['PRIVATE_KEY']

  def initialize(names)
    @names = names
  end
  
  def self.call(...)
    new(...).call
  end

  def call
    @names.map{ |name| process_request(make_url(name), name) }
  end

  private
  def make_url(name)
    ts = Time.now.to_i
    hash = Digest::MD5.hexdigest(ts.to_s + PRIVATE_KEY + PUBLIC_KEY)
    "#{HOST}#{name}&ts=#{ts}&apikey=#{PUBLIC_KEY}&hash=#{hash}"
  end

  def process_request(url, character)
    begin
      response = Faraday.get(url)
    rescue
      raise StandardError, 'Sorry, connection to Marvel database failed', []
    else
      process_data(response.body, character)
    end
  end

  def process_data(data, character)
    result = JSON.parse(data, symbolize_names: true)[:data].fetch(:results)
    raise StandardError, "Sorry. Character <<#{character}>> is not found! Choose another", [] if result.empty?

    result.first.slice(:name, :description)
  end

end