require 'rails_helper'

RSpec.describe UploadedFile, type: :model do
  let(:uploaded_file) { create(:uploaded_file, :with_attachment) }

  describe "ActiveModel validations" do
    it { expect(uploaded_file).to validate_presence_of(:user) }
    it { expect(uploaded_file).to validate_presence_of(:filename) }
    it { expect(uploaded_file).to validate_presence_of(:status) }

    it { expect(uploaded_file).to allow_value("filename.csv").for(:filename) }

    it { expect(uploaded_file).to define_enum_for(:status).with_values([:waiting, :processing, :failed, :done]) }
  end

  describe "ActiveRecord associations" do
    it { expect(uploaded_file).to have_one_attached(:csv_file) }
    it { expect(uploaded_file).to belong_to(:user) }
    it { expect(uploaded_file).to have_many(:contacts) }
    it { expect(uploaded_file).to have_many(:bad_contacts) }

    it { expect(uploaded_file).to have_db_column(:filename).of_type(:string).with_options(null: false) }
    it { expect(uploaded_file).to have_db_index(:user_id) }
  end
end
