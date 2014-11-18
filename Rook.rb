#require_relative 'SlidingPiece'

class Rook < SlidingPiece

  def moves
    super(DELTAS[:straightlines])
  end
end
