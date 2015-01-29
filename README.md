Description
=======
This is Chess, playable from the terminal, implemented in Ruby. To play against the computer, simply run chess.rb.

To see human versus human, load chess.rb in irb or pry, and do Game.new(HumanPlayer.new,HumanPlayer.new).play

Highlights
======
The most complex logic is in the special rules.

The possibility of En Passant is tracked by the board object, with instance variables for the position that a pawn could move to with En Passant, and the Pawn object that would be captured by such a move. Whenever a pawn is scanning for legal moves, it compares a potential diagonal move to the board's en passant move.

With Castling, if the king has not yet moved, it scans all of the conditions for castling (Rook hasn't moved, no pieces between King and Rook, King doesn't move through an attacked space), and allows the move if they are met.

To determine whether a move would be self-check, we create a duplicate of the board object, make the move, and look for attacks on the King.

Future Features
==========
Allow the use of Chess Notation for move inputs.

An all-around nicer interface.

Better AI!
