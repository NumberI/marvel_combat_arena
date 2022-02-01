#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'processing_request'
require 'battle_service'
require 'dotenv/load'

def fight
  # внутри метода необязательно заворачивать все в begin/rescue/end.

  # тут лучше кинуть специфичную ошибку, и не перехватывать её
  raise ArgumentError, 'You need to write 3 arguments', [] if ARGV.length != 3
  raise ArgumentError, 'You need to point a suitable number', [] unless ARGV[2].to_i.between?(1, 9)

  fighters = ProcessingRequest.call([ARGV[0], ARGV[1]])
  result = BattleService.call(fighters, ARGV[2].to_i)
  p '-' * 80
  p 'Result:'
  p result
  # Лучше не перехватывать вообще все ошибки (а все ошибки унаследованы от StandardError),
  # а ожидать только определенные ошибки, которые ты сам кидаешь.
  # Так мы будем строить поведение системы именно на прокидывании и перехвате конкретных ошибок,
  # все остальные ошибки считаем не предусмотреными программой, и они не должны перехватываться (мы должны падать)
rescue ProcessingRequest::ResponseDataError, ProcessingRequest::CharacterNotFound,
       ProcessingRequest::ConnectionError => e
  p e.message
  # rescue StandardError => e
  #   p e.message
end

def check_keys
  Dotenv.require_keys('PUBLIC_KEY', 'PRIVATE_KEY')
end

check_keys
fight
