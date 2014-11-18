#require_relative 'SteppingPiece'

class Knight < SteppingPiece
    
  def render
    (color == :black) ? "\u265E" : "\u2658"
  end
end
