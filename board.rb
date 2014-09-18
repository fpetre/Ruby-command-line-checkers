require_relative 'piece.rb'

class Board

  attr_accessor :board

  def initialize
    @board = Array.new(8){Array.new(8)}
    self.set_up_board
  end


  def set_up_board
    #top pieces
    (0..2).each do |y|
      (0..7).each do |x|
        # p "light x #{x}, y #{y}"
        Piece.new(:l, [x,y], self) if (x + y + 1) % 2 == 0
      end
    end

    #bottom pieces
    (5..7).each do |y|
      (0..7).each do |x|
        # p "dark x #{x}, y #{y}"
        Piece.new(:d, [x,y], self) if (x + y + 1) % 2 == 0
      end
    end
  end

  def add_piece(piece, pos)
    self[pos]= piece
  end

  def valid_pos?(pos)
    (0..7).include?(pos[0]) && (0..7).include?(pos[1])
  end

  def [](pos)
    x = pos[0]
    y = pos[1]

    self.board[y][x]
  end

  def []=(pos, piece)
    #p pos
    #p piece.color
    x = pos[0]
    y = pos[1]

    self.board[y][x] = piece
  end

  def inspect
    p "board"
  end

  def render
    puts "  " + (0..7).to_a.join("   ")
    a = self.board.map.with_index do |row, row_indx|
          "#{row_indx}" + row.map do |square|
            square ? " #{square.color} " : " * "
          end.join(" ")
        end.join("\n")
        puts a
  end


end