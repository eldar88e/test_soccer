FactoryBot.define do
  factory :statistic do
    association :player
    association :match

    trait :goalkeeper do
      saves { rand(0..10) }
      interceptions { rand(0..10) }
      distribution { rand(0..10) }
    end

    trait :forward do
      goals { rand(0..5) }
      assists { rand(0..5) }
      shots { rand(0..10) }
    end

    trait :midfielder do
      goals { rand(0..5) }
      assists { rand(0..5) }
      tackles { rand(0..10) }
    end

    trait :defender do
      assists { rand(0..5) }
      tackles { rand(0..10) }
      blocks { rand(0..10) }
    end
  end
end