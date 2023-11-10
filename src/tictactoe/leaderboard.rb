module TicTacToe
  class Leaderboard
    def initialize(general_score, player_scores)
      @general_score = general_score
      @player_scores = player_scores
    end

    def general_score
      @general_score
    end

    def each_player_scores(&block)
      @player_scores.each(&block)
    end
  end
end
