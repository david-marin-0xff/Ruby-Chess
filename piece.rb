#require_relative 'Board'

class Piece
  attr_reader :color

  def initialize(pos,board,color)
    @pos = pos
    @board = board
    @color = color
  end

  def moves
    "moves"
  end

  def valid_moves
  end
end
