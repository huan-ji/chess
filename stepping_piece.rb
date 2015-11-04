require 'byebug'

require_relative 'piece'
class SteppingPiece < Piece
  def moves
    # byebug
    possible_moves = []

    move_diffs.each do |diff|
      row, col = self.pos[0] + diff[0], self.pos[1] + diff[1]

      next if row < 0 || col < 0 || row > 7 || col > 7

      if board.grid[row][col].is_a? Piece
        piece = board.grid[row][col]
        possible_moves << [row, col] if self.color != piece.color
      else
        possible_moves << [row, col]
      end
    end

    possible_moves.delete(pos)
    possible_moves
  end
end

class Knight < SteppingPiece
  def initialize(color, pos, board)
    super(color, pos, board)
    color == "black" ? @sym = "♞" : @sym = "♘"
  end

  def move_diffs
    diffs = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
    ]
  end
end

class King < SteppingPiece
  def initialize(color, pos, board)
    super(color, pos, board)
    color == "black" ? @sym = "♚" : @sym = "♔"
  end

  def move_diffs
    diffs = [
      [1, 0],
      [-1, 0],
      [0, 1],
      [0, -1],
      [1, 1],
      [-1, -1],
      [1, -1],
      [-1, 1]
    ]
  end
end
