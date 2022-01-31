#!/usr/bin/env ruby

require 'bundler/setup'
require 'processing_request'
require 'battle_service'
require 'dotenv/load'

def fight
  begin
    raise StandardError, 'You need to write 3 arguments', [] if ARGV.length != 3
    raise StandardError, 'You need to point a suitable number', [] unless ARGV[2].to_i.between?(1, 9)
  rescue StandardError => e
    p e.message
  else
    fighters = ProcessingRequest.call([ARGV[0], ARGV[1]])
    result = BattleService.call(fighters, ARGV[2].to_i)

    p '-' * 80
    p 'Result:'
    p result
  end
end

def check_keys
  Dotenv.require_keys("PUBLIC_KEY", "PRIVATE_KEY")
end

check_keys
fight
