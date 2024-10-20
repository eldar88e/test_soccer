class Match < ApplicationRecord
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'
  has_many :statistics

  validates :date, presence: true
  validates :importance, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  validate :teams_must_be_different

  private

  def teams_must_be_different
    if home_team == away_team
      errors.add(:away_team, "не может быть такой же, как домашняя команда")
    end
  end
end
