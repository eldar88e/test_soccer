class StatisticsController < ApplicationController
  def index
    cache_key = generate_cache_key(params)
    response  = Rails.cache.fetch(cache_key, expires_in: 10.minutes)
    return render json: response, status: :ok if response

    @team = Rails.cache.fetch("team_#{params[:team_id]}", expires_in: 10.minutes) do
      find_team
    end
    return render json: { error: "Team not found" }, status: :not_found if @team.nil?

    @statistics = Rails.cache.fetch("team_#{@team.id}_statistics", expires_in: 10.minutes) do
      fetch_statistics
    end
    return render json: { team: @team.name, players: [] }, status: :ok if @statistics.blank?

    if params[:role].present?
      result = filter_by_role
      return render json: { error: "Role not found" }, status: :not_found if result.blank?
    end

    filter_by_date
    filter_by_players
    paginate_statistics
    response = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      { team: @team.name, players: @page }.merge(@pagination_info)
    end
    render json: response, status: :ok
  end

  private

  def generate_cache_key(params)
    key_parts = %W[team_#{params[:team_id]} team_#{params[:team_name]} role_#{params[:role]} from_#{params[:from]} to_#{params[:to]} top_#{params[:top]} page_#{params[:page]}]
    key_parts.join("_")
  end

  def paginate_statistics
    page     = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i
    offset   = (page - 1) * per_page
    @page    = @players[offset, per_page] || []

    @pagination_info = {
      page: page,
      per_page: per_page,
      pages: (@players.size / per_page.to_f).ceil,
      items: @players.size
    }
  end

  def filter_by_players
    players_rating = @statistics.map do |statistic|
      { name: statistic.player.name, role: statistic.player.role.name, rating: statistic.rating }
    end
    players_unique = combine_player_ratings players_rating
    @players       = players_unique.sort_by { |i| -i[:rating] }
    @players       = @players.take(params[:top].to_i) if params[:top].present?
  end

  def find_team
    args_team        = {}
    args_team[:id]   = params[:team_id].to_i if params[:team_id]
    args_team[:name] = params[:team_name] if params[:team_name]
    args_team.present? ? Team.find_by(args_team) : nil
  end

  def fetch_statistics
    Statistic.joins(player: :team)
             .where(players: { team_id: @team.id })
             .includes(:match, player: :role)
  end

  def filter_by_role
    role = roles.find_by('LOWER(name) = ?', params[:role].downcase)
    return if role.blank?

    @statistics = @statistics.where(players: { role: role })
  end

  def filter_by_date
    from    = params[:from]&.to_date
    to      = params[:to]&.to_date
    return if from.nil? && to.nil?

    matches = Match.where(home_team: @team).or(Match.where(away_team: @team)).order(date: :desc)
    matches = matches.where('date >= ?', from) if from
    matches = matches.where('date <= ?', to) if to
    @statistics = @statistics.where(match: matches)
  rescue => e
    Rails.logger.error e.message
  end

  def combine_player_ratings(players)
    player_unique = []
    players.each do |player|
      result = player_unique.find { |i| i[:name] == player[:name] && i[:role] == player[:role] }

      if result
        result[:rating] += player[:rating]
      else
        player_unique << { name: player[:name], role: player[:role], rating: player[:rating] }
      end
    end
    player_unique
  end

  def roles
    @roles ||= Role.all
  end
end
