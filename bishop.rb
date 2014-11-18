#require_relative 'SlidingPiece'

class Bishop < SlidingPiece

  def moves
    super(DELTAS[:diagonals])
  end
end
