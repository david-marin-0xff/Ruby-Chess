#require_relative 'SteppingPiece'

class King < SteppingPiece
  def render
    color == :black ? "\u265A" : "\u2654"
  end
end
