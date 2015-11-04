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
    return board
  end

  attr_accessor :grid, :king_pos_hash, :current_piece_valid_moves, :selected_piece_pos

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @king_pos_hash = {}
    @current_piece_valid_moves = []
    @selected_piece_pos = []
    @white_positions = {}
    @black_positions = {}
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
      grid.each_with_index do |row, row_i|
        row.each_with_index do |col, col_i|
          tile = self[[row_i, col_i]]
          next unless (tile.is_a? Piece) && (tile.color == color)

          return false unless tile.valid_moves.empty?
        end
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
  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]
    self[end_pos] = piece
    piece.pos = end_pos
    self[start_pos] = BlankSpace.new
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
    #
    # self.send("#{color}_positions".to_sym)

    self[[row, 0]] = Rook.new(color, [row, 0], self)
    self[[row, 7]] = Rook.new(color, [row, 7], self)
    self[[row, 1]] = Knight.new(color, [row, 1], self)
    self[[row, 6]] = Knight.new(color, [row, 6], self)
    self[[row, 2]] = Bishop.new(color, [row, 2], self)
    self[[row, 5]] = Bishop.new(color, [row, 5], self)
    self[[row, 3]] = Queen.new(color, [row, 3], self)
    self[[row, 4]] = King.new(color, [row, 4], self)
    king_pos_hash[color] = self[[row, 4]]
  end

  def populate_pawn_row(color, row)
    8.times do |col|
      self[[row, col]] = Pawn.new(color, [row, col], self)
    end
  end
end
#
# board = Board.populate
# board[[2, 3]] = Knight.new("white", [2, 3], board)
# p board.king_pos_hash["black"].pos
# p board.in_check?("black")
