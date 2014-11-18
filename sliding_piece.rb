#require_relative 'Piece'

class SlidingPiece < Piece

  def moves
  end

  def diag_moves
  end

  def line_moves
    moves = []
    (@pos.first+1...8).each do |x|
      new_pos = [x, @pos.last]

      if @board[new_pos].nil?
        moves << new_pos
      else
        moves << new_pos if @board[new_pos].color != @color
        break
      end
    end

    (@pos.first-1).downto(0).each do |x|
      new_pos = [x, @pos.last]

      if @board[new_pos].nil?
        moves << new_pos
      else
        moves << new_pos if @board[new_pos].color != @color
        break
      end
    end

    (@pos.last+1...8).each do |x|
      new_pos = [@pos.first, x]

      if @board[new_pos].nil?
        moves << new_pos
      else
        moves << new_pos if @board[new_pos].color != @color
        break
      end
    end

    (@pos.last-1).downto(0) do |x|
      new_pos = [@pos.first, x]

      if @board[new_pos].nil?
        moves << new_pos
      else
        moves << new_pos if @board[new_pos].color != @color
        break
      end
    end

    moves
  end

end
