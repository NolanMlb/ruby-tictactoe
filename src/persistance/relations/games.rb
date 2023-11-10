module Persistance
  module Relations
    class Games < ROM::Relation[:memory]
      gateway :memory

      schema(:games) do
        attribute :id, Types::String
        attribute :player_x_id, Types::String
        attribute :player_o_id, Types::String

        attribute :winner, Types::String.optional

        attribute :status, Types::String # ongoing, finished

        primary_key :id

        associations do
          has_many :moves, combine_key: :id, override: true, view: :for_games
          belongs_to :players, as: :player_x, combine_key: :player_x_id, override: true, view: :for_game_x, foreign_key: :player_x_id
          belongs_to :players, as: :player_o, combine_key: :player_o_id, override: true, view: :for_game_o, foreign_key: :player_o_id
        end
      end

      def by_pk(id)
        restrict(id: id)
      end

      def ongoing
        restrict(status: 'ongoing')
      end

      def finished
        restrict(status: 'finished')
      end
    end
  end
end
