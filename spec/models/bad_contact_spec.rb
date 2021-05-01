require 'rails_helper'

RSpec.describe BadContact, type: :model do
  let(:bad_contact) { create(:bad_contact) }

  describe "ActiveModel validations" do
    it { expect(bad_contact).to validate_presence_of(:user_id) }
    it { expect(bad_contact).to validate_presence_of(:uploaded_file_id) }
    it { expect(bad_contact).to serialize(:credit_card) }
  end

  describe "ActiveRecord associations" do
    it { expect(bad_contact).to belong_to(:user) }
    it { expect(bad_contact).to belong_to(:uploaded_file) }

    it { expect(bad_contact).to have_db_column(:address).of_type(:string) }
    it { expect(bad_contact).to have_db_column(:birth_date).of_type(:string) }
    it { expect(bad_contact).to have_db_column(:credit_card).of_type(:string) }
    it { expect(bad_contact).to have_db_column(:email).of_type(:string) }
    it { expect(bad_contact).to have_db_column(:name).of_type(:string) }
    it { expect(bad_contact).to have_db_column(:phone).of_type(:string) }
    it { expect(bad_contact).to have_db_index(:user_id) }
    it { expect(bad_contact).to have_db_index(:uploaded_file_id) }
  end
end
