#require_relative 'SteppingPiece'

class King < SteppingPiece
  DELTAS = [[0,1],[1,0],[0,-1],[-1,0],[1,1],[-1,-1],[1,-1],[-1,1]]

  def moves
    super(DELTAS)
  end

  def render
    color == :black ? "\u265A" : "\u2654"
  end
end
