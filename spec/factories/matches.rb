FactoryBot.define do
  factory :match do
    date { Faker::Date.between(from: Date.today.prev_year.to_s, to: Date.today.to_s) }
    importance { rand(1..5) }
    association :home_team, factory: :team
    association :away_team, factory: :team

    after(:create) do |match|
      match.home_team.players.each do |player|
        create(:statistic, player.role.name.downcase.to_sym, player: player, match: match)
      end

      match.away_team.players.each do |player|
        create(:statistic, player.role.name.downcase.to_sym, player: player, match: match)
      end
    end
  end
end
