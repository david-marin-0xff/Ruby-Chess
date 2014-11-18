#require_relative 'Board'

class Piece
  attr_reader :color
  attr_accessor :pos

  def initialize(board,color)
    @pos = nil
    @board = board
    @color = color
  end

  def inspect
    "#{pos} #{color}"
  end

  def moves
    "moves"
  end

  def valid_moves
  end

  def render
  end
end
