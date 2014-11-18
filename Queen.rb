#require_relative 'SlidingPiece'

class Queen < SlidingPiece
  def moves
    super(DELTAS[:diagonals]) + super(DELTAS[:straightlines])
  end
end
