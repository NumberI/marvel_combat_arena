#!/usr/bin/env ruby

class BattleService

  def initialize(characters, seed)
    @characters = characters
    @seed = seed
    @winners_count = 0
  end
  
  def self.call(...)
    new(...).call
  end

  def call
    chosen_words = @characters.map { |character| process_description(character, @seed) }
    compare_words(chosen_words, @characters)
  end

  private
  
  def process_description(hero, word_number)
    words = hero.fetch(:description).gsub(/\.|,/, '').downcase.split(' ')
    @winners_count += 1 if %w(Gamma Radioactive).any? { |s| words.include? s.downcase }
    
    words[word_number]
  end

  def compare_words(words, heroes)
    if @winners_count == 2
      'They are both winners!'
    elsif words[0].to_s.length > words[1].to_s.length
      "The winner is <<#{heroes[0].fetch(:name)}>>"
    elsif words[0].to_s.length < words[1].to_s.length
      "The winner is <<#{heroes[1].fetch(:name)}>>"
    else
      "It's a tie!"
    end
  end

end