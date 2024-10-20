class Role < ApplicationRecord
  has_many :players

  validates :name, presence: true, uniqueness: true
  validates :coefficients, presence: true
end
