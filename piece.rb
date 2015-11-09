require 'byebug'
require 'colorize'
require 'set'
class Piece
  attr_accessor :pos, :color, :board, :current_possible_moves, :relevant_positions

  def initialize(color, pos, board)
    @color, @pos, @board = color, pos, board
    @current_possible_moves = []
    @relevant_positions = Set.new
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
      board.positions_and_dependent_pieces[pos].add(self)
      relevant_positions.add(pos)
      return true
    end
    false
  end

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
        unless is_piece?(move)
          possible_moves << move
          board.positions_and_dependent_pieces[move].add(self)
          relevant_positions.add(move)
        end
        diags = [[pos[0] - 1, pos[1] + 1], [pos[0] - 1, pos[1] - 1]]
      elsif color == "black"
        move = [pos[0] + space_allowed, pos[1]]
        unless is_piece?(move)
          possible_moves << move
          board.positions_and_dependent_pieces[move].add(self)
          relevant_positions.add(move)
        end
        diags = [[pos[0] + 1, pos[1] + 1], [pos[0] + 1, pos[1] - 1]]
      end
    end

    diags.each do |diag|
      board.positions_and_dependent_pieces[diag].add(self)
      relevant_positions.add(diag)
      if is_piece?(diag)
        possible_moves << diag if board[diag].color != self.color
      end
    end
    possible_moves.delete(pos)
    possible_moves
  end
end
