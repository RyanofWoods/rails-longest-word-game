class GamesController < ApplicationController
  def new
    @letters = []
    # create 10 random letters
    10.times { @letters << ('A'..'Z').to_a[rand(26)] }
  end
  def score
    @letters = params[:letters].split()
    @answer = params[:answer].upcase
    @errors = []
    check_letters = @letters.clone
    check_answer = @answer.chars

    # preinitialise
    all_included = true

    # iterate over every answer letter
    check_answer.each do |letter|
      # check if answer letter is in the random word
      if check_letters.include?(letter)
        # delete the letter from the check_letters and
        # make sure not to delete every instance of that letter
        index = check_letters.index(letter)
        check_letters.delete_at(index)
      else
        errors << "Not all of your letters are included in the grid"
        all_included = false
        break
      end
    end

    # next: check if it is an english word
  end
end
