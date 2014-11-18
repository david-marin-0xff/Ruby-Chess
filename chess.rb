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

class Game
  def initialize(player1, player2)
    @board = Board.new
    @players = {:white => player1, :black => player2}
  end

  def play

    turn = :white

    until @board.checkmate?(:white) || @board.checkmate?(:black)
      @board.display

      begin
        @players[turn].play_turn(@board,turn)
      rescue => e
        puts "#{e.message}"
        @board.display
        retry
      end

      turn = turn == :white ? :black : :white
    end
  end

end

class HumanPlayer
  def play_turn(board,color)
    puts "Input your move."
    input = gets.chomp

    coords = input.split(/\s+/)

    if coords.length != 2 || coords.any? { |coord| coord !~ /^[a-hA-H]{1}\d{1}$/ }
      raise "bad input!"
    end

    move = HumanPlayer.translate_coords(coords)
    board.move(move[0],move[1],color)

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
