require_relative 'board'
require_relative 'player'

class Game
  attr_reader :board, :current_player
  def initialize(player1, player2)
    @board = Board.populate
    @player1 = Player.new(@board, player1, "white", self)
    @player2 = Player.new(@board, player2, "black", self)
    @current_player = @player1
  end

  def switch_players
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end
  def get_piece
    begin
      selected_piece = @current_player.select_piece
    rescue PieceError
      puts "Must select a valid piece"
      retry
    end
    # highlight code
    board.current_piece_valid_moves = board[selected_piece].valid_moves
    board.selected_piece_pos = selected_piece
  end

  def get_move
    begin
      selected_valid_move = @current_player.select_valid_move
    rescue ValidMoveError
      puts "Invalid move"
      retry
    end
  end

  def run
    until board.check_mate?
      begin
        selected_piece = get_piece
        selected_valid_move = get_move
      rescue SelfSelectError
        board.selected_piece_pos = []
        board.current_piece_valid_moves = []
        retry
      end
      @board.move(selected_piece, selected_valid_move)
      board.selected_piece_pos = []
      board.current_piece_valid_moves = []
      switch_players
    end
    puts "Check mate!!"
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new("White", "Black")
  game.run
end
