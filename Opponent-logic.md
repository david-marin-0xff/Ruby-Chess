# ♟️ How the AI Opponent Works

👉 Your computer opponent is **very simple**.  
It’s not a real chess AI — it’s basically a **greedy + random bot**.

---

## 🧠 How the Computer Chooses Moves

The logic lives here:

```ruby
class ComputerPlayer
  def play_turn(board, color)
```

This method decides **one move per turn**.

---

## 🔍 Step 1: Look at all your pieces

```ruby
our_pieces = board.pieces(color)
```

👉 The computer gets **all its pieces** (black pieces in your game).

---

## 🔍 Step 2: Look at enemy pieces

```ruby
enemy_pieces = board.pieces(color == :black ? :white : :black)
enemy_positions = enemy_pieces.map(&:pos)
```

👉 It finds:
- All your pieces  
- Their positions on the board  

---

## ⚔️ Step 3: Try to CAPTURE something

This is the **most important part**:

```ruby
piece_moves = piece.valid_moves
cap_moves = piece_moves.select { |move| enemy_positions.include?(move) }
```

👉 For each piece:
- Get all valid moves  
- Filter moves that land on an enemy piece  

➡️ Now it only considers **capture moves**.

---

## 💰 Step 4: Pick the MOST valuable capture

```ruby
best = cap_moves.max_by { |move| PIECE_VALUES[board[move].class] }
```

### Piece values:

```ruby
PIECE_VALUES = {
  Queen => 9,
  Rook => 5,
  Knight => 3,
  Bishop => 3,
  Pawn => 1
}
```

👉 The computer prefers:

- Queen (9) 🔥  
- Rook (5)  
- Knight / Bishop (3)  
- Pawn (1)  

💡 **Example:**
If it can capture a pawn OR a queen → it picks the queen.

---

## 🏆 Step 5: Keep the BEST capture overall

```ruby
if val > best_val
  best_move = [piece.pos, best]
  best_val = val
end
```

👉 It compares all captures and keeps the **highest value move**.

---

## 🎲 Step 6: If no captures → RANDOM move

```ruby
if best_val.zero?
  piece = our_pieces.reject { |p| p.valid_moves.empty? }.sample
  move = piece.valid_moves.sample
```

👉 If it **can’t capture anything**, it:
- Picks a random piece  
- Picks a random valid move  

💀 This is why the AI sometimes looks *“dumb”*.

---

## 🚀 Step 7: Execute the move

```ruby
board.move(best_move[0], best_move[1], color)
```

👉 The move is played on the board.

---

## ♟️ Step 8: Pawn promotion (auto-queen)

```ruby
board.promote_pawn(Queen, color) if board.pawn_promotion
```

👉 If a pawn reaches the end:
- It **always becomes a Queen**

---

## 🧾 Final Output

```ruby
ComputerPlayer.translate_coords(best_move)
```

👉 Converts `[row, col]` back into chess notation like:

```
e2 e4
```

---

## 🧠 What kind of AI is this?

👉 This is called a **Greedy Algorithm**

Because it:
- Only looks at **immediate gain**
- Doesn’t think ahead
- Doesn’t simulate future moves

---

## ❌ What it does NOT do

Your AI does NOT:

- ❌ Look ahead (no minimax)
- ❌ Avoid traps
- ❌ Protect pieces
- ❌ Check for checkmate setups
- ❌ Evaluate board positions

---

## 🧪 Example Behavior

**Situation:**
- It can capture a pawn  
- But that move loses its queen next turn  

👉 It will STILL capture the pawn 😅

Because: “Pawn = value 1 → good enough”

---

## 💡 Why this is actually good (for learning)

This is a **perfect beginner AI** because:

- Easy to understand ✅  
- Easy to improve ✅  
- You can clearly see its weaknesses ✅  

---

## 🚀 How to Improve It

Next step:

👉 Implement the **Minimax algorithm**

This would allow the AI to:
- Think ahead  
- Evaluate positions  
- Play MUCH stronger  
