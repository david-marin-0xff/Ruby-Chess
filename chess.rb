require_relative 'board'
require_relative 'piece'
require_relative 'stepping_piece'
require_relative 'sliding_piece'
require_relative 'king'
require_relative 'queen'
require_relative 'rook'
require_relative 'bishop'
require_relative 'knight'
require_relative 'pawn'
require          'colorize'

PROMOTIONS = {"queen" => Queen,
          "rook" => Rook,
          "bishop" => Bishop,
          "knight" => Knight}

class Game
  def initialize(player1, player2)
    @board = Board.new
    @players = {:white => player1, :black => player2}
  end

  def play

    turn = :white

    until @board.checkmate?(turn) || @board.stalemate?(turn)
      @board.display

      begin
        @players[turn].play_turn(@board,turn)
      rescue MyChessError => e
        puts "#{e.message}"
        @board.display
        retry
      end

      turn = turn == :white ? :black : :white

      puts "Check!" if @board.in_check?(turn)
    end

    @board.display

    if @board.checkmate?(turn)
      winner = turn == :white ? :black : :white
      puts "Checkmate! The winner is #{winner}."
    else
      puts "The game is a draw."
    end
  end

end

class HumanPlayer
  def play_turn(board,color)
    puts "#{color.to_s.capitalize} to move.  Input your move."
    input = gets.chomp

    coords = input.split(/\s+/)

    if coords.length != 2 || coords.any? { |coord| coord !~ /^[a-hA-H]{1}\d{1}$/ }
      raise MyChessError.new("bad input!")
    end

    move = HumanPlayer.translate_coords(coords)
    board.move(move[0],move[1],color)
    check_promotion(board, color)
  end

  def check_promotion(board, color)
    if board.pawn_promotion
      begin
        puts "What piece would you like to promote to?"
        piece = gets.chomp.downcase
        board.promote_pawn(piece, color)
      rescue MyChessError => e
        puts "#{e.message}"
        board.display
        retry
      end
    end
  end

  def self.translate_coords(coords)
    new_coords = []
    coords.each do |coord|
      new_coords_one = coord[0].downcase.bytes[0] - 97
      new_coords_two = 8 - coord[1].to_i
      new_coords << [new_coords_two, new_coords_one]
    end
    new_coords
  end
end

class ComputerPlayer
  def play_turn(board)
  end
end

class MyChessError < StandardError
end
