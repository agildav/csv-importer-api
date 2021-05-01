FactoryBot.define do
  factory :bad_contact do
    address { Faker::Address.full_address }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }
    credit_card { Faker::Finance.credit_card(:mastercard, :visa) }
    email { Faker::Internet.email }
    name { Faker::JapaneseMedia::SwordArtOnline.game_name.first(10) }
    phone { Faker::PhoneNumber.cell_phone_in_e164 }
    uploaded_file { create(:uploaded_file, :with_attachment) }
    user { uploaded_file.user }
  end
end
