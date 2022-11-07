class GamesController < ApplicationController
  def new
    @letters = generate_grid.shuffle!
  end

  def score; end

  private

  def generate_grid
    ('a'..'z').to_a.sample(9)
  end
end
