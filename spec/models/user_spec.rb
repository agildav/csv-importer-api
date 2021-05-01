require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "ActiveModel validations" do
    it { expect(user).to validate_presence_of(:email) }
    it { expect(user).to validate_uniqueness_of(:email).case_insensitive }
    it { expect(user).to validate_uniqueness_of(:token).case_insensitive }
    it { expect(user).to have_secure_password }
  end

  describe "ActiveRecord associations" do
    it { expect(user).to have_many(:contacts).dependent(:destroy) }
    it { expect(user).to have_many(:bad_contacts).dependent(:destroy) }
    it { expect(user).to have_many(:uploaded_files).dependent(:destroy) }

    it { expect(user).to have_db_column(:email).of_type(:string).with_options(null: false) }
    it { expect(user).to have_db_column(:token).of_type(:string) }
    it { expect(user).to have_db_index(:email).unique(:true) }
    it { expect(user).to have_db_index(:token).unique(:true) }
  end
end
