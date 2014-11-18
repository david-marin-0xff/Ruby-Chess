#require_relative 'SlidingPiece'

class Rook < SlidingPiece

  def moves
    super(DELTAS[:straightlines])
  end

  def render
    color == :black ? "\u265C" : "\u2656"
  end
end
