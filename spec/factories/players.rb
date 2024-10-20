FactoryBot.define do
  factory :player do
    name { Faker::Sports::Football.player }
    association :team

    trait :goalkeeper do
      role { Role.find_by(name: 'Goalkeeper') }
    end

    trait :defender do
      role { Role.find_by(name: 'Defender') }
    end

    trait :midfielder do
      role { Role.find_by(name: 'Midfielder') }
    end

    trait :forward do
      role { Role.find_by(name: 'Forward') }
    end
  end
end