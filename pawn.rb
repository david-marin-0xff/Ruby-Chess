#require_relative 'Piece'

class Pawn < Piece

  def render
    color == :black ? "\u265F" : "\u2659"
  end
end
