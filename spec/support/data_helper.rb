module DataHelper
  DATA_FOR_POST = {
    "data": {
      "importance": 2,
      "date": "2024-02-02",
      "home_team": {
        "name": "Pumas",
        "statistics": [
          { "name": "Player 1", "role": "Goalkeeper", "saves": 5, "interceptions": 2, "distribution": 2 },
          { "name": "Player 2", "role": "Forward", "goals": 2, "assists": 2, "shots": 2 },
          { "name": "Player 3", "role": "Forward", "goals": 1, "assists": 4, "shots": 3 },
          { "name": "Player 4", "role": "Midfielder", "assists": 2, "tackles": 8 },
          { "name": "Player 5", "role": "Midfielder", "assists": 2, "tackles": 8 },
          { "name": "Player 6", "role": "Midfielder", "assists": 2, "tackles": 8 },
          { "name": "Player 7", "role": "Midfielder", "assists": 2, "tackles": 8 },
          { "name": "Player 8", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 },
          { "name": "Player 9", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 },
          { "name": "Player 10", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 },
          { "name": "Player 11", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 }
        ]
      },
      "away_team": {
        "name": "Titans",
        "statistics": [
          { "name": "Player 1", "role": "Goalkeeper", "saves": 8, "interceptions": 2, "distribution": 2 },
          { "name": "Player 2", "role": "Forward", "goals": 1, "assists": 2, "shots": 2 },
          { "name": "Player 3", "role": "Forward", "assists": 4, "shots": 3 },
          { "name": "Player 4", "role": "Midfielder", "assists": 2, "tackles": 8 },
          { "name": "Player 5", "role": "Midfielder", "assists": 2, "tackles": 8 },
          { "name": "Player 6", "role": "Midfielder", "assists": 2, "tackles": 8 },
          { "name": "Player 7", "role": "Midfielder", "goals": 1, "assists": 2, "tackles": 8 },
          { "name": "Player 8", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 },
          { "name": "Player 9", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 },
          { "name": "Player 10", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 },
          { "name": "Player 11", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 }
        ]
      }
    }
  }

  ROLES = [
    { name: 'Goalkeeper', coefficients: { "saves": 3, "distribution": 1, "interceptions": 2 } },
    { name: 'Defender', coefficients: { "blocks": 3, "assists": 1, "tackles": 2 } },
    { name: 'Forward', coefficients: { goals: 3, shots: 1, assists: 2 } },
    { name: 'Midfielder', coefficients: { goals: 3, assists: 2, tackles: 1 } }
  ]

  def create_role
    ROLES.each { |role| Role.create(role) }
  end

  def create_team_with_players_and_statistics
    create_role
    team    = create(:team, name: 'team1', create_players: false)
    team2   = create(:team, name: 'team2')
    player1 = create(:player, :goalkeeper, name: 'player1', team: team )
    player2 = create(:player, :defender, name: 'player2', team: team)
    create(:player, :defender, name: 'player3', team: team)
    create(:player, :defender, name: 'player4', team: team)
    create(:player, :midfielder, name: 'player5', team: team)
    create(:player, :forward, name: 'player6', team: team)
    match1  = create(:match, importance: 2, home_team: team, away_team: team2, date: '2024-10-01')
    match2  = create(:match, importance: 3, home_team: team2, away_team: team, date: '2024-10-15')

    create(:statistic, player: player1, match: match1, saves: 5, interceptions: 2)
    create(:statistic, player: player2, match: match2, tackles: 3, blocks: 4)
    create(:statistic, player: player1, match: match1, saves: 3, interceptions: 4)
    create(:statistic, player: player2, match: match2, tackles: 2, blocks: 3)

    CalculatePlayerRatingJob.perform_now

    {
      team: team,
      players: [player1, player2],
      matches: [match1, match2],
      statistics: Statistic.joins(player: :team).where(players: { team: team }).includes(:match, player: :role)
    }
  end
end
