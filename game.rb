require_relative 'board.rb'
require_relative 'player.rb'
require 'colorize'

class Game

  attr_reader :board, :player1, :player2

  def initialize(player1, player2)
    @board = Board.new(true)
    @player1 = [:d, player1]
    @player2 = [:l, player2]
  end

  def play
    current_player = self.player1
    until game_over?
      p "cp #{current_player[0]}"
      self.board.render
      puts "it is #{current_player[0]}'s turn"
      begin
      current_player[1].take_turn(board,current_player[0])
      p "left take_turn"
      rescue StandardError => e
        puts e.message
        retry
      end
      current_player = current_player[0] == :d ? self.player2 : self.player1
    end
    "#{who_won} won!"
  end

  def game_over?
    self.who_won

  end

  def who_won
    if self.board.pieces.all?{|piece| piece.color == :d}
      :dark
    elsif self.board.pieces.all?{|piece| piece.color == :l}
      :white
    else
      nil
    end
  end


end