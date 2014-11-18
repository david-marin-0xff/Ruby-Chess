#require_relative 'Piece'

class Board
  def initialize(grid = nil, pieces = {:white => [], :black => [] })
    @pieces = pieces

    if grid.nil?
      @grid = Array.new(8) { Array.new(8) }
      setup_pieces
    else
      @grid = grid
    end
  end

  def in_check?(color)
    enemy_color = color == :black ? :white : :black

    our_king_idx = @pieces[color].index { |piece| piece.is_a?(King) }

    our_king_pos = @pieces[color][our_king_idx].pos

    @pieces[enemy_color].any? { |piece| p piece.moves; piece.moves.include?(our_king_pos) }
  end

  def inspect
    @grid
  end

  def move(start_pos,end_pos)
    raise if self[start_pos].nil?
    raise unless self[start_pos].moves.include?(end_pos)

    unless self[end_pos].nil?
      color = self[end_pos].color
      @pieces[color].delete(self[end_pos])
    end

    self[end_pos] = self[start_pos]
    self[start_pos] = nil
  end

  def dup
    grid_copy = @grid.dd_map
    pieces_copy = {:black => @pieces[:black].dup, :white => @pieces[:white].dup}
    board_copy = Board.new(grid_copy, pieces_copy)
    pieces_copy[:black].each { |piece| piece.board = board_copy }
    pieces_copy[:white].each { |piece| piece.board = board_copy }
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
    setup_nonpawn(0, :black)
    setup_nonpawn(7, :white)

    (0..7).each do |i|
      self[[1, i]] = Pawn.new(self, :black)
      @pieces[:black] << self[[1,i]]
      @pieces[:black] << self[[0,i]]
      self[[6, i]] = Pawn.new(self, :white)
      @pieces[:white] << self[[6,i]]
      @pieces[:white] << self[[7,i]]
    end
  end

  def setup_nonpawn(row, color)
    self[[row,0]] = Rook.new(self, color)
    self[[row,1]] = Knight.new(self, color)
    self[[row,2]] = Bishop.new(self, color)
    self[[row,3]] = Queen.new(self, color)
    self[[row,4]] = King.new(self, color)
    self[[row,5]] = Bishop.new(self, color)
    self[[row,6]] = Knight.new(self, color)
    self[[row,7]] = Rook.new(self, color)
  end

end
