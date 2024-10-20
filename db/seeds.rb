roles = [
  { name: 'Goalkeeper', coefficients: { saves: 3, interceptions: 2, distribution: 1 } },
  { name: 'Forward', coefficients: { goals: 3, assists: 2, shots: 1 } },
  { name: 'Midfielder', coefficients: { goals: 3, assists: 2, tackles: 1 } },
  { name: 'Defender', coefficients: { assists: 1, tackles: 2, blocks: 3 } }
]

roles.each do |role|
  Role.create(role)
end

team_names = %w[Lions Tigers Bears Eagles Sharks Wolves Dragons Knights Hawks Panthers]

team_names.each do |team_name|
  FactoryBot.create(:team, name: team_name)
end

teams = Team.all
teams.each do |team|
  for_away_teams = teams - [team]
  FactoryBot.create(:match, home_team: team, away_team: for_away_teams.sample)
end

puts 'Started Seeding rating'

CalculatePlayerRatingJob.perform_now

puts 'Seed success!'
