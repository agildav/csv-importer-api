FactoryBot.define do
  factory :uploaded_file do
    association :user, factory: :user, strategy: :create
    filename { "upload_file.csv" }
    trait :with_attachment do
      csv_file { FilesTestHelper.csv }
    end
  end
end
