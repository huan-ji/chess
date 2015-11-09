require 'byebug'
require_relative 'piece'

class SlidingPiece < Piece
  def moves
    # debugger
    queue = []
    possible_moves = []

    move_dirs.each do |dir|
      queue = [self.pos]
      until queue.empty?
        shifted_pos = queue.shift
        possible_moves << shifted_pos
        # debugger
        board.positions_and_dependent_pieces[shifted_pos].add(self)
        relevant_positions.add(shifted_pos)
        row, col = shifted_pos[0] + dir[0], shifted_pos[1] + dir[1]
        if row < 0 || col < 0 || row > 7 || col > 7
          break
        else
          if is_piece?([row, col])
            piece = board[[row, col]]
            if self.color != piece.color
              possible_moves << [row, col]
              break
            else
              break
            end
          else
            queue << [row, col]
          end
        end
      end
    end

    possible_moves =  possible_moves.uniq
    possible_moves.delete(pos)
    possible_moves
  end
end

class Rook < SlidingPiece
  def initialize(color, pos, board)
    super(color, pos, board)
    color == "black" ? @sym = "♜" : @sym = "♖"
  end
  
  def move_dirs
    dirs = [
      [1, 0],
      [-1, 0],
      [0, 1],
      [0, -1]
    ]
  end
end

class Bishop < SlidingPiece
  def initialize(color, pos, board)
    super(color, pos, board)
    color == "black" ? @sym = "♝" : @sym = "♗"
  end

  def move_dirs
    dirs = [
      [1, 1],
      [-1, -1],
      [1, -1],
      [-1, 1]
    ]
  end
end

class Queen < SlidingPiece
  def initialize(color, pos, board)
    super(color, pos, board)
    color == "black" ? @sym = "♛" : @sym = "♕"
  end

  def move_dirs
    dirs = [
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
