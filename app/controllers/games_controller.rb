require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @answer = (params[:answer] || '').upcase
    @included = included?(@answer, @letters)
    @english_word = english_word?(@answer)
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(answer)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{answer}")
    json = JSON.parse(response.read)
    json['found']
  end
end
