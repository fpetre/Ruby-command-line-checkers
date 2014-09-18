class Piece
attr_reader :color, :board
attr_accessor :pos
attr_writer :king

PIECE_MOVE_DELTA = [[1,1], [-1,1]]
KING_MOVE_DELTA = [[1,1], [-1,1], [1,-1], [-1,-1]]

  def initialize(color, pos, board)
    @king = false
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

  def move_diffs
    moves = []
    x = self.pos[0]
    y = self.pos[1]

    use_delta = self.king? ? KING_MOVE_DELTA : PIECE_MOVE_DELTA
    if self.color == :l
      use_delta.each do |d_x, d_y|
        new_pos = [d_x + x, d_y + y]
        moves << [d_x,d_y] if self.board.valid_pos?(new_pos)
      end
    else
      use_delta.each do |d_x, d_y|
        new_pos = [d_x + x, y - d_y]
        moves << [d_x,(-d_y)] if self.board.valid_pos?(new_pos)
      end
    end
    moves
  end

  def perform_slide(target)
    new_moves = self.move_diffs.collect{|d_x, d_y| [d_x + pos[0], d_y + pos[1]]}
    return false unless new_moves.include?(target) && board[target].nil?
      self.board[pos] = nil
      self.board[target] = self
      self.pos = target

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

    self.board[pos] = nil
    self.board[target_mid_move] = nil
    self.board[target] = self
    self.pos = target

    true
  end

  def mid_move(target)
    d_x = (target[0] - self.pos[0])/2
    d_y = (target[1] - self.pos[1])/2

    mid_move = [d_x + self.pos[0], d_y + self.pos[1]]
  end





end