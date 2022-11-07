class GamesController < ApplicationController
  def new
    @letters = generate_grid.shuffle!
  end

  def score; end

  private

  def generate_grid
    ('a'..'z').to_a.sample(9)
  end

  def run_game(attempt, grid)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    attempt_serialized = URI.open(url).read
    attempt_json = JSON.parse(attempt_serialized)['found']
    final_result = {
      attempt:,
      # time: end_time - start_time,
      score: 0,
      message: "<strong>Congratulatons</strong> #{@attempt.upcase} is a valid English word!"
    }
    display_result(final_result, attempt_json, grid, attempt)
  end

  def display_result(final_result, attempt_json, grid, attempt)
    if attempt_json then final_result = result(final_result, attempt, grid)
    else
      final_result[:message] = "<strong>#{attempt.upcase}</strong> not an english word"
    end
    final_result
  end
end
