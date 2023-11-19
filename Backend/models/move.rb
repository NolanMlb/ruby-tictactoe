class Move < ActiveRecord::Base
    # Associations
    belongs_to :game
  
    # Validations
    validates :x_pos, :y_pos, presence: true
  end
  