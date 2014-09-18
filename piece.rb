class InvalidMoveError < StandardError
end


class Piece
attr_reader :color, :board
attr_accessor :pos
attr_writer :king

PIECE_MOVE_DELTA = [[1,1], [-1,1]]
KING_MOVE_DELTA = [[1,1], [-1,1], [1,-1], [-1,-1]]

  def initialize(color, pos, board, king = false)
    @king = king
    @color = color #raise exception if not black or white
    @pos = pos # raise exception if not on board
    @board = board
    board.add_piece(self, @pos)
  end

  def king?
    @king
  end

  def render
    self.king? ? "#{self.color}K" : self.color
  end

  def maybe_promote
    if self.color == :d
      if self.pos[1] == 0 # cant do it on one line?
        self.king = true
      else
        return false
      end
    else
      if self.pos[1] == 7
        self.king = true
      else
        return false
      end
    end
  end

  def move_diffs
    moves = []
    x = self.pos[0] #oneline
    y = self.pos[1]

    use_delta = self.king? ? KING_MOVE_DELTA : PIECE_MOVE_DELTA

    use_delta.each do |d_x, d_y|
      if self.color == :l
        new_pos = [d_x + x, d_y + y]
        moves << [d_x,d_y] if self.board.valid_pos?(new_pos)
      else
        new_pos = [d_x + x, y - d_y]
        moves << [d_x,(-d_y)] if self.board.valid_pos?(new_pos)
      end
    end

    moves
  end

  def move!(target)
    self.board[self.pos] = nil
    self.board[target] = self
    self.pos = target
  end

  def perform_slide(target)
    new_moves = self.move_diffs.collect{|d_x, d_y| [d_x + self.pos[0], d_y + self.pos[1]]}
    return false unless new_moves.include?(target) && self.board[target].nil?
    self.move!(target)
    self.maybe_promote
    true
  end

  def perform_jump(target)
    jump_moves = self.move_diffs.collect do|d_x, d_y|
      jump_move = [(d_x * 2) + pos[0], (d_y * 2) + pos[1]]
      mid_move = [d_x + pos[0], d_y + pos[1]]
      next unless self.board.valid_pos?(jump_move) && !self.board[mid_move].nil? &&
      self.board[mid_move].color != self.color
      jump_move
    end.compact

    return false unless jump_moves.include?(target) && board[target].nil?

    target_mid_move = self.mid_move(target)
    self.board[target_mid_move] = nil
    self.move!(target)
    self.maybe_promote
    true
  end

  def mid_move(target)
    d_x = (target[0] - self.pos[0])/2
    d_y = (target[1] - self.pos[1])/2

    mid_move = [d_x + self.pos[0], d_y + self.pos[1]]
  end

  def perform_moves!(move_sequence)
    if move_sequence.count <= 1
      raise InvalidMoveError, "invalid sequence!" unless self.perform_slide(move_sequence[0]) ||
      self.perform_jump(move_sequence[0])
    else
      move_sequence.each do |target|
        raise InvalidMoveError, "invalid sequence!" unless self.perform_jump(target)
      end
    end
    nil
  end

  def valid_move_sequence?(move_sequence)
    new_board = self.board.dup
    begin
      new_board[self.pos].perform_moves!(move_sequence)
    rescue InvalidMoveError => e
      return false
    end
    true
  end

  def perform_moves(move_sequence)
    if self.valid_move_sequence?(move_sequence)
       self.perform_moves!(move_sequence)
    else
       raise InvalidMoveError, "invalid sequence!"
    end
    nil
  end

end