FactoryBot.define do
  factory :team do
    name { Faker::Sports::Football.team }

    transient do
      create_players { true }
    end

    after(:create) do |team, evaluator|
      if evaluator.create_players
        create(:player, :goalkeeper, team: team)
        create_list(:player, 2, :forward, team: team)
        create_list(:player, 3, :midfielder, team: team)
        create_list(:player, 4, :defender, team: team)
        create(:player, [:forward, :midfielder].sample, team: team)
      end
    end
  end
end
