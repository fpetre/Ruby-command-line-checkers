class HumanPlayer

  def take_turn(board,color)
    puts "please enter position of piece you would like to move eg: 2,3"
    start_pos = self.translate_moves(gets.chomp)[0]
    raise InvalidMoveError, "No piece there!" if board[start_pos].nil?
    #p "start color #{board[start_pos].color} position #{start_pos}"
    raise InvalidMoveError, "Not Your Piece!" if board[start_pos].color != color
    puts "please enter move or series of moves eg: 2,3 ; 4,5"
    moves = self.translate_moves(gets.chomp)
    board[start_pos].perform_moves(moves)
  end

  def translate_moves(moves)
    new_moves = moves.split(";").map do |move|
      move.split(",").map{|pos| Integer(pos)}
    end
  end

end
