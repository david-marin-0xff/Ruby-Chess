require_relative 'Board'

class Piece

  def initialize(pos,board)
    @position = pos
    @board = board
  end

  def moves
    "moves"
  end

  def valid_moves
  end
end
