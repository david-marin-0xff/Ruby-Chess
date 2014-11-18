#require_relative 'Piece'

class Board
  def initialize
    @grid = Array.new(8) {Array.new(8)}
    # @white_pieces = []
    # @black_pieces = []
  end

  def in_check?(color)
  end

  def move(start_pos,end_pos)
  end

  def dup
  end

  def [](pos)
    @grid[pos.first][pos.last]
  end

  def put_piece(piece)
    self[pos] = piece
  end
end
