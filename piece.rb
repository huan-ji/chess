require 'byebug'
require 'colorize'
class Piece
  attr_accessor :pos, :color, :board

  def initialize(color, pos, board)
    @color, @pos, @board = color, pos, board
  end

  def present?
    true
  end

  def to_s
    " #{@sym} "
  end

  def valid_moves
    # debugger
    valid_moves_array = []

    moves.each do |move|
      start_pos = pos
      end_pos = move
      if board[end_pos].is_a? Piece
        enemy_piece = board[end_pos]
        board.move!(start_pos, end_pos)
        valid_moves_array << move if !self.board.in_check?(color)
        board.move!(end_pos, start_pos)
        board[end_pos] = enemy_piece
      else
        board.move!(start_pos, end_pos)
        valid_moves_array << move if !self.board.in_check?(color)
        board.move!(end_pos, start_pos)
      end
    end

    valid_moves_array
  end

  def is_piece?(pos)
    if board[pos].is_a? Piece
      
end

class BlankSpace
  def present?
    false
  end

  def to_s
    "   "
  end
end

class Pawn < Piece
  attr_accessor :moved

  def initialize(color, pos, board)
    @moved = false
    super(color, pos, board)
    color == "black" ? @sym = "♟" : @sym = "♙"
  end

  def moves
    possible_moves = []
    spaces_allowed = 0 #(@moved ? [1] : [1, 2])
    if @moved
      spaces_allowed = [1]
    else
      spaces_allowed = [1, 2]
    end

    diags = []
    spaces_allowed.each do |space_allowed|
      if color == "white"
        move = [pos[0] - space_allowed, pos[1]]
        possible_moves << move unless board.grid[move[0]][move[1]].is_a? Piece
        diags = [[pos[0] - 1, pos[1] + 1], [pos[0] - 1, pos[1] - 1]]
      elsif color == "black"
        move = [pos[0] + space_allowed, pos[1]]
        possible_moves << move unless board.grid[move[0]][move[1]].is_a? Piece
        diags = [[pos[0] + 1, pos[1] + 1], [pos[0] + 1, pos[1] - 1]]
      end
    end

    diags.each do |diag|
      piece = board.grid[diag[0]][diag[1]]
      if piece.is_a? Piece
        possible_moves << diag if piece.color != self.color
      end
    end
    possible_moves.delete(pos)
    possible_moves
  end
end
