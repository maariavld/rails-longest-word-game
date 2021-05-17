require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_code(12)
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    @result = score_and_result(@word, @grid)
  end

  def generate_code(number)
    Array.new(number) { ('A'..'Z').to_a.sample }
  end

  def included?(word, grid)
   word.upcase.chars.all? { |letter| grid.include?(letter) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    english_word = URI.open(url).read
    word = JSON.parse(english_word)
    return word['found']
  end

  def score_and_result(attempt, grid)
    if included?(attempt, grid)
      if english_word?(attempt)
        score = attempt.length
        return "Congratulations! Your score is #{score}"
      else
        return "Your #{attempt.upcase} is not an English word!Score:0"
      end
    else
      return "Your #{attempt.upcase} is not in the grid! Score:0"
    end
  end
end
