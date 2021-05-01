FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::JapaneseMedia::SwordArtOnline.game_name.first(25) }
  end
end
