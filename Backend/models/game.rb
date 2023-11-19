class Game < ActiveRecord::Base
    # Associations
    belongs_to :player_x, class_name: 'Player', foreign_key: :player_x_id
    belongs_to :player_o, class_name: 'Player', foreign_key: :player_o_id
    has_many :moves
  
    # Validations
    validates :status, presence: true, inclusion: { in: %w[ongoing finished] }
  end
  