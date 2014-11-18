#require_relative 'Piece'

class Board
  def initialize(grid = nil)
    if grid.nil?
      @grid = Array.new(8) { Array.new(8) }
      setup_pieces
    else
      @grid = grid
    end
  end

  def pieces(color)
    @grid.flatten.compact.select do |piece|
      piece.color == color
    end
  end

  def in_check?(color)
    enemy_color = color == :black ? :white : :black

    our_king = pieces(color).select do |piece|
      piece.is_a?(King)
    end

    our_king_pos = our_king[0].pos

    pieces(enemy_color).any? do |piece|
      piece.moves.include?(our_king_pos)
    end
  end

  def checkmate?(color)
    in_check?(color) && pieces(color).all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def inspect
    @grid
  end

  def move(start_pos,end_pos, color)
    raise "no piece @ start_pos" if self[start_pos].nil?
    raise "invalid move" unless self[start_pos]
          .valid_moves.include?(end_pos) &&
          self[start_pos].color == color

    self.move!(start_pos, end_pos)
  end

  def move!(start_pos, end_pos)
    raise "no piece @ start_pos" if self[start_pos].nil?

    unless self[end_pos].nil?
      color = self[end_pos].color
    end

    self[end_pos] = self[start_pos]
    self[start_pos] = nil
  end

  def dup
    grid_copy = Array.new(8) {Array.new(8)}
    board_copy = Board.new(grid_copy)

    grid_copy.each_index do |row|
      grid_copy[row].each_index do |col|
        next if @grid[row][col].nil?
        piece = @grid[row][col]
        board_copy[[row,col]] = piece.class.new(board_copy, piece.color)
      end
    end

    board_copy
  end

  def [](pos)
    @grid[pos.first][pos.last]
  end

  def []=(pos,piece)
    @grid[pos.first][pos.last] = piece
    piece.pos = pos unless piece.nil?
  end

  def display
    puts "  A B C D E F G H"
    @grid.each_with_index do |row, idx|
      print "#{8 - idx} "
      row.each do |space|
        if space.nil?
          print "_ "
        else
          print space.render + " "
        end
      end
      print "#{8 - idx} "
      puts
    end
    puts "  A B C D E F G H"
    nil
  end

  private

  def setup_pieces
    setup_nonpawn(0, :black)
    setup_nonpawn(7, :white)

    (0..7).each do |i|
      self[[1, i]] = Pawn.new(self, :black)
      self[[6, i]] = Pawn.new(self, :white)
    end
  end

  def setup_nonpawn(row, color)
    nonpawn_row = [Rook, Knight, Bishop,
      Queen, King, Bishop, Knight, Rook]
    nonpawn_row.each_with_index do |piece_class, i|
      self[[row, i]] = piece_class.new(self, color)
    end
  end

end
