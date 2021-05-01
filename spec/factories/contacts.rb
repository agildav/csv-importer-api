FactoryBot.define do
  factory :contact do
    address { Faker::Address.full_address }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }
    credit_card { ['4605342255762509', '4716338708591285', '4532257949361286', '6011253776175324', '3528664071363725'].sample }
    email { Faker::Internet.email }
    name { Faker::JapaneseMedia::SwordArtOnline.game_name.first(10) }
    phone { ['(+58) 414 323 07 31', '(+58) 424 323 07 31', '(+58) 412 745 09 33', '(+58) 426 642 09 17'].sample }
    uploaded_file { create(:uploaded_file, :with_attachment) }
    user { uploaded_file.user }
  end
end
