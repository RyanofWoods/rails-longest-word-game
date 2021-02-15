class GamesController < ApplicationController
  def new
    @letters = []
    # create 10 random letters
    10.times { @letters << ('A'..'Z').to_a[rand(26)] }
  end
  def score
    @answer = params[:answer]
  end
end
