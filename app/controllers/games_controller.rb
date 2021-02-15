require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    # create 10 random letters
    10.times { @letters << ('A'..'Z').to_a[rand(26)] }
    @time_start = Time.now.to_i
  end
  def score
    letters = params[:letters].split()
    answer = params[:answer].upcase
    time_start = params[:time_start].to_i
    seconds_taken = Time.now.to_i - time_start
    check_letters = letters.clone
    check_answer = answer.chars
    score = 0
    @results = []

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
        @results << "#{answer} can't be built out of #{letters.join(", ")}"
        all_included = false
        break
      end
    end

    # next: check if it is an english word
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    word_serialized = open(url).read
    word_result = JSON.parse(word_serialized)

    in_dictionary = word_result["found"]

    unless in_dictionary
      @results << "#{answer} does not seem to be a valid English word..."
    end

    if in_dictionary && all_included
      if seconds_taken > 30
        @results << "Your word was valid, but you took more than 30 seconds..."
      else
        score = answer.length + (30 / seconds_taken)

        @results << "Congratulations! #{answer} is a valid English word!"
        @results << "You took #{seconds_taken} seconds to guess"
        @results << "You just got: #{score} points!"
        if session[:grand_score]
          session[:grand_score] = session[:grand_score] + score
        else
          session[:grand_score] = score
        end
          @results << "Your grand score: #{session[:grand_score]}"
      end
    end
  end
end
