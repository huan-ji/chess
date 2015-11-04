require_relative 'display'

class Player
  attr_reader :name, :color, :board
  def initialize(board, name, color, game)
    @display = Display.new(board, game)
    @name = name
    @color = color
    @board = board
    @game = game
  end

  def select_piece
    # debugger
    result = nil
    until result
      @display.render
      result = @display.get_input
    end
    piece = board[result]
    if (piece.is_a? Piece) && piece.color == color
      result
    else
      raise PieceError
    end
  end

  def select_valid_move
    result = nil
    until result
      @display.render
      result = @display.get_input
    end
    if board.current_piece_valid_moves.include?(result)
      result
    else
      if board.selected_piece_pos == result
        raise SelfSelectError
      else
        raise ValidMoveError
      end
    end
  end
end

class PieceError < RuntimeError
end

class ValidMoveError < RuntimeError
end

class SelfSelectError < RuntimeError
end
