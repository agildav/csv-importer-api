require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) { create(:contact) }

  describe "ActiveModel validations" do
    it { expect(contact).to validate_presence_of(:user_id) }
    it { expect(contact).to validate_presence_of(:uploaded_file_id) }
    it { expect(contact).to validate_presence_of(:email) }
    it { expect(contact).to validate_uniqueness_of(:email).scoped_to(:user_id) }
    it { expect(contact).to validate_presence_of(:name) }
    it { expect(contact).to validate_presence_of(:birth_date) }
    it { expect(contact).to validate_presence_of(:address) }
    it { expect(contact).to validate_presence_of(:credit_card) }
    it { expect(contact).to validate_presence_of(:phone) }
    it { expect(contact).to serialize(:credit_card) }
  end

  describe "ActiveRecord associations" do
    it { expect(contact).to belong_to(:user) }
    it { expect(contact).to belong_to(:uploaded_file) }

    it { expect(contact).to have_db_column(:address).of_type(:string).with_options(null: false) }
    it { expect(contact).to have_db_column(:birth_date).of_type(:date).with_options(null: false) }
    it { expect(contact).to have_db_column(:credit_card).of_type(:string).with_options(null: false) }
    it { expect(contact).to have_db_column(:email).of_type(:string).with_options(null: false) }
    it { expect(contact).to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { expect(contact).to have_db_column(:phone).of_type(:string).with_options(null: false) }
    it { expect(contact).to have_db_index(:user_id) }
    it { expect(contact).to have_db_index(:uploaded_file_id) }
  end

  describe ".credit_card" do
    context "when record is saved" do
      it "encrypts the value" do
        expect(contact.credit_card_before_type_cast).not_to eq(contact.credit_card)
      end
    end
  end
end
