class SaveGameJob < ApplicationJob
  queue_as :default

  def perform(**args)
    save_player_with_stat(args[:home_team], args[:home_team_statistics], args[:current_match])
    save_player_with_stat(args[:away_team], args[:away_team_statistics], args[:current_match])
    CalculatePlayerRatingJob.perform_later(match_id: args[:current_match].id)
  end

  private

  def save_player_with_stat(team, statistics, current_match)
    roles ||= Role.all
    statistics.each do |stat|
      role     = roles.find_by(name: stat['role'])
      player   = Player.find_or_create_by(team: team, name: stat['name'], role: role)
      cur_stat = stat.except('name', 'role')
      Statistic.create(player: player, match: current_match, **cur_stat)
    end
  end
end
