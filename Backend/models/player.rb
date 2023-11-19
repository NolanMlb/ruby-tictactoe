class Player < ActiveRecord::Base
    # Associations
    has_many :player_x_games, class_name: 'Game', foreign_key: :player_x_id
    has_many :player_o_games, class_name: 'Game', foreign_key: :player_o_id
  
    # Validations
    validates :name, presence: true
  end
  