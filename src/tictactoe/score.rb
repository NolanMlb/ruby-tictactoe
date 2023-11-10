module TicTacToe
  class Score
    def initialize(games_count, finished_games_count, draw_games_count, x_victories_count, o_victories_count)
      @games_count = games_count
      @finished_games_count = finished_games_count
      @draw_games_count = draw_games_count
      @x_victories = x_victories_count
      @o_victories = o_victories_count
    end

    def +(other)
      Score.new(
        @games_count + other.games_count,
        @finished_games_count + other.finished_games_count,
        @draw_games_count + other.draw_games_count,
        @x_victories + other.x_victories,
        @o_victories + other.o_victories,
      )
    end

    def games_count
      @games_count
    end

    def games_finished
      @finished_games_count
    end

    def games_finished_percentage
      @finished_games_count.to_f / @games_count
    end

    def games_draw
      @draw_games_count
    end

    def games_draw_percentage
      @draw_games_count.to_f / @games_count
    end

    protected

    attr_reader :finished_games_count, :draw_games_count, :x_victories, :o_victories
  end
end
