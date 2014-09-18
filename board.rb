require_relative 'piece.rb'

class Board

  attr_accessor :board

  def initialize(new_board)
    @board = Array.new(8){Array.new(8)}
     self.set_up_board if new_board
  end


  def set_up_board
    #top pieces
    (0..2).each do |y|
      (0..7).each do |x|
        Piece.new(:l, [x,y], self) if (x + y + 1) % 2 == 0
      end
    end

    #bottom pieces
    (5..7).each do |y|
      (0..7).each do |x|
        Piece.new(:d, [x,y], self) if (x + y + 1) % 2 == 0
      end
    end
  end

  def add_piece(piece, pos)
    self[pos]= piece
  end

  def valid_pos?(pos)
    (0..7).include?(pos[0]) && (0..7).include?(pos[1]) # one line .all?
  end

  def [](pos)
    x, y = pos

    self.board[y][x]
  end

  def []=(pos, piece)
    x, y = pos

    self.board[y][x] = piece
  end

  def inspect
    p "board"
  end

  def render
    puts "  " + (0..7).to_a.join("   ")
    a = self.board.map.with_index do |row, row_indx|
          "#{row_indx}" + row.map do |square|
            square ? " #{square.render} " : " * "
          end.join(" ")
        end.join("\n")
        puts a
  end

  def pieces
    self.board.flatten.compact
  end


  def dup
    new_board = Board.new(false)
    pieces.each do |piece|
      piece.class.new(piece.color, piece.pos, new_board, piece.king?)
    end
    new_board
  end


end