require_relative 'piece.rb'

class Board

  attr_accessor: :board
  def initialize
    @board = Array.new(8){Array.new(8)}
    self.set_up_board
  end


  def set_up_board
    #top pieces
    board[0...3].each_with_index do |row, y|
      row.each_with_index do |square, x|
        Piece.new(:light, [x, y], self) if X + Y % 2 == 0
      end
    end

    #bottom pieces
    board[5..7].each_with_index do |row, y|
      row.each_with_index do |square, x|
        y += 5
        Piece.new(:dark, [x, y], self) if X + Y % 2 == 0
      end
    end
  end




end