#require_relative 'Piece'

class Pawn < Piece

  def initialize(board,color)
    super(board,color)
    @first_move = true
  end

  attr_accessor :first_move

  def moves
    moves = []
    direction = @color == :black ? 1 : -1

    if @first_move
      new_pos = [pos.first+2*direction,pos.last]
      moves << new_pos if @board[new_pos].nil?
    end

    new_pos = [pos.first + direction, pos.last]
    moves << new_pos if @board[new_pos].nil? && new_pos.first.between?(0,7)

    new_pos = [pos.first + direction, pos.last + 1]
    moves << new_pos if !@board[new_pos].nil? && @board[new_pos].color != color

    new_pos = [pos.first + direction, pos.last - 1]
    moves << new_pos if !@board[new_pos].nil? && @board[new_pos].color != color

    moves
  end

  def render
    color == :black ? "\u265F" : "\u2659"
  end
end
