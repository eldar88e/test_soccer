class MatchesController < ApplicationController
  def create
    data = params[:data]&.to_unsafe_h
    return render json: { error: "Data is empty" }, status: :not_found if data.blank?

    home_team_name = data.dig('home_team', 'name')
    return return_error if home_team_name.blank?

    @home_team = Team.find_or_create_by(name: home_team_name)
    update_team_or_statistics(@home_team)
    away_team_name = data.dig('away_team', 'name')
    return return_error if away_team_name.blank?

    @away_team = Team.find_or_create_by(name: away_team_name)
    update_team_or_statistics(@away_team)
    current_match = Match.create(away_team: @away_team,
                                 home_team: @home_team,
                                 date: data['date'],
                                 importance: data['importance'])

    result = save_game_and_statistic(data, current_match)
    return render json: { error: "Statistic is empty" }, status: :not_found if result.nil?

    render json: { status: "Success save!" }, status: :ok
  end

  private

  def update_team_or_statistics(team)
    Rails.cache.delete("team_#{team.id}")
    Rails.cache.delete("team_#{team.id}_statistics")
  end

  def save_game_and_statistic(data, current_match)
    home_team_stat = data.dig('home_team', 'statistics')
    away_team_stat = data.dig('away_team', 'statistics')
    return if home_team_stat.blank? || away_team_stat.blank?

    SaveGameJob.perform_later(
      home_team: @home_team,
      away_team: @away_team,
      current_match: current_match,
      home_team_statistics: home_team_stat,
      away_team_statistics: away_team_stat
    )
    true
  end

  def return_error
    render json: { error: "Data is not correct" }, status: :not_found
  end
end
