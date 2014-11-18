#require_relative 'Piece'

class Board
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @white_pieces = []
    @black_pieces = []
    setup_pieces
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

  def []=(pos,piece)
    @grid[piece.pos] = nil unless piece.pos.nil?
    @grid[pos.first][pos.last] = piece
    piece.pos = pos
  end

  def display
    @grid.each do |row|
      row.each do |space|
        if space.nil?
          print "_ "
        else
          print space.render + " "
        end
      end
      puts
    end
    nil
  end

  private

  def setup_pieces
    @grid[1] = Array.new(8) { Pawn.new(self, :black) }
    @grid[1].each { |pawn| @black_pieces << pawn }

    @grid[6] = Array.new(8) { Pawn.new(self, :white) }
    @grid[6].each { |pawn| @white_pieces << pawn }

    setup_nonpawn(@grid[0], :black)
    @grid[0].each { |nonpawn| @black_pieces << nonpawn }
    setup_nonpawn(@grid[7], :white)
    @grid[7].each { |nonpawn| @white_pieces << nonpawn }
  end

  def setup_nonpawn(row, color)
    row[0] = Rook.new(self, color)
    row[1] = Knight.new(self, color)
    row[2] = Bishop.new(self, color)
    row[3] = Queen.new(self, color)
    row[4] = King.new(self, color)
    row[5] = Bishop.new(self, color)
    row[6] = Knight.new(self, color)
    row[7] = Rook.new(self, color)
  end

end
