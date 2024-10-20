class CalculatePlayerRatingJob < ApplicationJob
  queue_as :default

  def perform(**args)
    option     = args[:match_id] ? { match_id: args[:match_id] } : { rating: nil }
    statistics = Statistic.where(option).includes(player: :role)
    statistics.each do |statistic|
      soccer_match = statistic.match
      importance   = soccer_match.importance
      role   = statistic.player.role.coefficients
      rating = role.reduce(0) { |sum, (key, val)| sum + ((statistic[key] || 0) * val * importance) }
      statistic.update(rating: rating)
    end

    nil
  end
end
