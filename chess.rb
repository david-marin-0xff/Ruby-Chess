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
require          'yaml'

PROMOTIONS = {
  "queen"  => Queen,
  "rook"   => Rook,
  "bishop" => Bishop,
  "knight" => Knight
}

class Game
  def initialize(player1, player2)
    @board = Board.new
    @players = {:white => player1, :black => player2}
    @turn = :white
  end

  def play

    system "clear" or system "cls"
    puts

    until @board.checkmate?(@turn) || @board.stalemate?(@turn)
      @board.display(:white, :default, :light_white)

      begin
        move = @players[@turn].play_turn(@board,@turn)
        if move == "save"
          puts "Please enter filename:"
          fname = gets.chomp
          File.open(fname, 'w') do |f|
            f.puts self.to_yaml
          end
          puts "Game saved to file: \"#{fname}\"."
          return
        end
      rescue MyChessError => e
        system "clear" or system "cls"
        puts "#{e.message}"
        @board.display(:white, :default, :light_white)
        retry
      end

      system "clear" or system "cls"
      puts "#{@turn.to_s.capitalize}\'s move was #{move.chop}."

      @turn = (@turn == :white) ? :black : :white

      puts "Check!" if @board.in_check?(@turn)
    end

    @board.display(:white, :default, :light_white)

    if @board.checkmate?(@turn)
      winner = (@turn == :white) ? :black : :white
      puts "Checkmate! The winner is #{winner}."
    elsif @board.stalemate?(@turn)
      puts "The game is a draw."
    end
  end

end

class HumanPlayer

  def play_turn(board, color)
    puts "#{color.to_s.capitalize} to move.  Input your move."
    input = gets.chomp

    return "save" if input.downcase == "save"

    coords = input.split(/\s+/)

    if coords.length != 2 || coords.any? { |coord| coord !~ /^[a-hA-H]{1}\d{1}$/ }
      raise MyChessError.new("Bad input!")
    end

    move = HumanPlayer.translate_coords(coords)
    board.move(move[0],move[1],color)
    check_promotion(board, color)
    input
  end

  def check_promotion(board, color)
    if board.pawn_promotion
      begin
        puts "What piece would you like to promote to?"
        piece = gets.chomp.downcase
        board.promote_pawn(piece, color)
      rescue MyChessError => e
        puts "#{e.message}"
        board.display(:white, :default, :light_white)
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

  PIECE_VALUES = { Queen => 9,
                   Rook => 5,
                   Knight => 3,
                   Bishop => 3,
                   Pawn => 1}

  def play_turn(board, color)
    best_move = []
    best_val = 0

    our_pieces = board.pieces(color)
    enemy_pieces = board.pieces(color == :black ? :white : :black)

    enemy_positions = enemy_pieces.map { |piece| piece.pos }

    our_pieces.each do |piece|
      piece_moves = piece.valid_moves

      cap_moves = piece_moves.select { |move| enemy_positions.include?(move) }
      next if cap_moves.empty?
      best = cap_moves.max_by { |move| PIECE_VALUES[board[move].class] }
      val = PIECE_VALUES[board[best].class]
      if val > best_val
        best_move = [piece.pos,best]
        best_val = val
      end
    end

    if best_val.zero?
      piece = our_pieces.reject do |piece|
        piece.valid_moves.count.zero?
      end.sample

      move = piece.valid_moves.sample
      best_move = [piece.pos,move]
    end


    board.move(best_move[0],best_move[1],color)
    ComputerPlayer.translate_coords(best_move)
  end

  def self.translate_coords(coords)
    new_coords = ""
    coords.each do |coord|
      new_coords_one = (coord[1] + 97).chr
      new_coords_two = (8 - coord[0]).to_s
      new_coords << new_coords_one << new_coords_two << " "
    end
    new_coords
  end

end

class MyChessError < StandardError

end

if __FILE__ == $PROGRAM_NAME

  if ARGV.count == 0
    g = Game.new(HumanPlayer.new, HumanPlayer.new)
    g.play
  else
  end

end
