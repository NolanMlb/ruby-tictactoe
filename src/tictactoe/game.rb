module TicTacToe
  class Game
    attr_reader :id, :board, :current_player, :movement_index

    def self.new_game(id = nil)
      board = Array.new(3) { Array.new(3, nil) }
      current_player = "X"
      id = SecureRandom.uuid unless id

      new(board, current_player, id)
    end

    def initialize(board, current_player, id)
      @board = board
      @current_player = current_player
      @id = id

      @movement_index = 0
    end

    def play_turn(row, col)
      return false unless valid_move?(row, col)

      @board[row][col] = @current_player
      @movement_index += 1

      if winner?
        :winner
      elsif draw?
        :draw
      else
        switch_player
        :continue
      end
    end

    def valid_move?(row, col)
      (0..2).include?(row) && (0..2).include?(col) && @board[row][col].nil?
    end

    private

    def switch_player
      @current_player = @current_player == "X" ? "O" : "X"
    end

    def winner?
      # Check rows, columns, and diagonals
      (0..2).any? { |i| @board[i].all? { |cell| cell == @current_player } } ||
        (0..2).any? { |i| @board.all? { |row| row[i] == @current_player } } ||
        (0..2).all? { |i| @board[i][i] == @current_player } ||
        (0..2).all? { |i| @board[i][2 - i] == @current_player }
    end

    def draw?
      @board.all? { |row| row.all? { |cell| !cell.nil? } }
    end
  end
end
