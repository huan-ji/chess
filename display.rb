require "colorize"
require_relative "cursorable"
require_relative "board"

class Display
  include Cursorable

  attr_accessor :board

  def initialize(board, game)
    @board = board
    @cursor_pos = [0, 0]
    @game = game
  end

  def build_grid
    @board.grid.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    # debugger
    if [i, j] == @cursor_pos
      bg = :green
    elsif (board[@cursor_pos].is_a? Piece) && (board[@cursor_pos].current_possible_moves.include?([i, j]))
      bg = :yellow
    elsif board.selected_piece_pos == [i, j]
      bg = :light_red
    elsif (board.current_piece_valid_moves.include? [i, j])
      bg = :light_red
    elsif (i + j).odd?
      bg = :light_green
    elsif
      bg = :light_blue
    end
    { background: bg, color: :black }
  end

  def render
    system("clear")
    puts "#{@game.current_player.name}, make your move."
    puts "Arrow keys, WASD, or vim to move, space or enter to select piece."
    build_grid.each { |row| puts row.join }
  end
end
# if __FILE__ == $PROGRAM_NAME
#   board = Board.populate
#   display = Display.new(board)
#   display.render
# end
