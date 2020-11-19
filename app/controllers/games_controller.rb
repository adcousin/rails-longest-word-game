require 'open-uri'
require 'json'
require_relative 'application_controller'

class GamesController < ApplicationController
  def new
    session[:score] = session[:score] || 0
    alphabet = [('A'..'Z')].map(&:to_a)[0]
    @letters = []
    10.times { @letters << alphabet.sample }
  end

  def score
    return @result = "Don't fool me. Empty trial is not a trial." if params[:trial] == ''

    url = "https://wagon-dictionary.herokuapp.com/#{params[:trial]}"
    is_word = JSON.parse(open(url).read)['found']
    word = params[:trial].upcase.chars
    grid = params[:grid].split(' ')
    # 1. if trial est pas dans la liste stop
    if (word - grid).empty?
      grid.each do |letter|
        word.delete_at(word.index(letter)) if word.include?(letter)
      end
      return @result = "Sorry but #{params[:trial]} is not even in the grid : #{grid}." unless word.empty?
    else
      return @result = "Sorry but #{params[:trial]} is not even in the grid : #{grid}."
    end

    # 2. if trial est dans la liste mais pas dans le dico
    # 3. if trial est dans la liste et dans le dico
    if is_word
      @score = params[:trial].length
      # session[:score].nil? ? session[:score] = score : session[:score] += @score
      session[:score] += @score
      return @result = "Yeah! #{params[:trial]} can be built out of the grid: #{grid}. Your score is : #{@score}. User : #{session[:score]}"
    else
      return @result = "Sorry but although #{params[:trial]} is in the list, it is not an English word according to the API."
    end
  end
end
