require_relative 'piece'
require_relative 'sliding_piece'
require_relative 'stepping_piece'
class Board

  def self.populate
    board = Board.new
    board.populate_back_row("black", 0)
    board.populate_back_row("white", 7)
    board.populate_pawn_row("black", 1)
    board.populate_pawn_row("white", 6)
    board.populate_blank_spaces
    board.populate_possible_moves
    return board
  end

  attr_accessor :grid, :king_pos_hash, :current_piece_valid_moves, :selected_piece_pos, :white_pieces, :black_pieces

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @king_pos_hash = {}
    @current_piece_valid_moves = []
    @selected_piece_pos = []
    @white_pieces = {}
    @black_pieces = {}
    @positions_and_dependent_pieces = {}
  end

  def populate_possible_moves
    white_pieces.each { |piece, _| change_possible_moves(piece) }
    black_pieces.each { |piece, _| change_possible_moves(piece) }
  end

  def change_possible_moves(piece)

  end

  def in_check?(color)
    king_pos = king_pos_hash[color].pos

    grid.each_with_index do |row, row_i|
      row.each_with_index do |col, col_i|
        tile = self[[row_i, col_i]]

        if (tile.is_a? Piece) && (tile.color != color)
          return true if tile.moves.include?(king_pos)
        end
      end
    end
    false
  end

  def check_mate_color?(color)
    if in_check?(color)
      # debugger
      # grid.each_with_index do |row, row_i|
      #   row.each_with_index do |col, col_i|
      #     tile = self[[row_i, col_i]]
      #     next unless (tile.is_a? Piece) && (tile.color == color)
      #
      #     return false unless tile.valid_moves.empty?
      #   end
      # end

      hash = self.send("#{color}_pieces".to_sym)

      hash.each do |piece, pos|
        return false unless piece.valid_moves.empty?
      end

    elsif !in_check?(color)
      return false
    end
    true
  end

  def check_mate?
    # debugger
    ["black", "white"].each do |color|
      return true if check_mate_color?(color)
    end
    false
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]
    self[end_pos] = piece
    piece.pos = end_pos
    piece.moved = true if piece.is_a? Pawn
    self[start_pos] = BlankSpace.new

    hash = self.send("#{piece.color}_pieces".to_sym)
    hash[piece] = end_pos
  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]
    self[end_pos] = piece
    piece.pos = end_pos
    self[start_pos] = BlankSpace.new
    hash = self.send("#{piece.color}_pieces".to_sym)
    hash[piece] = end_pos
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(  pos, piece)
    @grid[pos[0]][pos[1]] = piece
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def populate_blank_spaces
    (2..5).each do |row|
      (0..7).each do |col|
        self[[row, col]] = BlankSpace.new
      end
    end
  end

  def populate_back_row(color, row)

    hash = self.send("#{color}_pieces".to_sym)
    left_edge = 0
    right_edge = 7

    populate_hash = {
      0 => Rook,
      1 => Knight,
      2 => Bishop
    }

    8.times do |col|
      populate_hash.each do |abso, piece|
        if (left_edge - col).abs == abso || (right_edge - col).abs == abso
          self[[row, col]] = piece.new(color, [row, col], self)
          hash[self[[row, col]]] = [row, col]
        end
      end
    end

    self[[row, 3]] = Queen.new(color, [row, 3], self)
    hash[self[[row, 3]]] = [row, 3]
    self[[row, 4]] = King.new(color, [row, 4], self)
    hash[self[[row, 4]]] = [row, 4]

    king_pos_hash[color] = self[[row, 4]]
  end

  def populate_pawn_row(color, row)
    hash = self.send("#{color}_pieces".to_sym)
    8.times do |col|
      self[[row, col]] = Pawn.new(color, [row, col], self)
      hash[self[[row, col]]] = [row, col]
    end
  end
end
#
# board = Board.populate
# # # board[[2, 3]] = Knight.new("white", [2, 3], board)
# # # p board.king_pos_hash["black"].pos
# # # p board.in_check?("black")
# p board.white_pieces.values
# p board.black_pieces.values
