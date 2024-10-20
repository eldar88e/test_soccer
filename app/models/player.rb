class Player < ApplicationRecord
  belongs_to :team
  belongs_to :role
  has_many :statistics
end
