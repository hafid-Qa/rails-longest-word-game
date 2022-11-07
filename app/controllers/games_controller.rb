# frozen_string_literal: true

require 'open-uri'
require 'json'
# define game logic
class GamesController < ApplicationController
  def new
    @letters = generate_grid.shuffle!
    # @sc= session[:score]ore
  end

  def score
    @attempt = params[:answer].downcase
    @grid = params[:grid].downcase
    @time_taken = Time.now - params[:start_time].to_datetime
    @final_result = run_game
  end

  def reset
    session[:score] = 0
    redirect_to root_path
  end

  private

  def generate_grid
    ('a'..'z').to_a.sample(9)
  end

  def run_game
    attempt_serialized = URI.open("https://wagon-dictionary.herokuapp.com/#{@attempt}")
    attempt_json = JSON.parse(attempt_serialized.read)['found']
    final_result = {
      attempt: @attempt,
      time: @time_taken,
      score: @score,
      message: "<strong>Congratulatons</strong> #{@attempt.upcase} is a valid English word!"
    }
    display_result(final_result, attempt_json, @grid, @attempt)
  end

  def display_result(final_result, attempt_json, grid, attempt)
    if attempt_json
      final_result = result(final_result, attempt, grid)
    else
      final_result[:message] = "<strong>#{attempt.upcase}</strong> not an english word"
    end
    final_result
  end

  def result(final_result, attempt, grid)
    if attempt.chars.all? { |letter| grid.include?(letter) } && count_letter?(attempt, grid)
      session[:score] += compute_score(attempt, final_result[:time])
    else
      final_result[:message] =
        "Sorry but <strong>#{@attempt.upcase}</strong> cant be build out of #{@grid.upcase.gsub(' ', ', ')}"
      # final_result[:score] = 0
    end
    final_result
  end

  def compute_score(attempt, time_after)
    time_after > 60.0 ? 0 : attempt.size * (1.0 - time_after / 60.0)
  end

  def count_letter?(attempt, grid)
    attempt.chars do |letter|
      return false unless attempt.count(letter) <= grid.split.count(letter)
    end
    true
  end

  # def games_params
  #   params.permit(:answer, :grid, :start_time)
  # end
  # end of class
end
