class Piece
attr_reader: :color, :pos, :board
  def initialize
    @color = color #raise exception if not black or white
    @pos = pos # raise exception if not on board
    @board = board
    board.add_piece(self, pos)
  end

  move_diffs


end