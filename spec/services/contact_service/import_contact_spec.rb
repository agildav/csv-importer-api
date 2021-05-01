require 'rails_helper'

RSpec.describe ContactService::ImportContact, type: :service do
  let(:user) { create(:user) }
  let(:csv_file) { FilesTestHelper.csv }
  let(:wrong_params) {
    {
      name: nil,
      email: nil,
      phone: nil,
      address: nil,
      birth_date: nil,
      credit_card: nil,
      file_csv: nil
    }
  }
  let(:valid_params) {
    {
      name: "name",
      email: "email",
      phone: "phone",
      address: "address",
      birth_date: "birth_date",
      credit_card: "credit_card",
      file_csv: csv_file
    }
  }
  let(:uploaded_file) { described_class.call(user, valid_params).result }

  context "when invalid parameters are passed" do
    it "raises errors" do
      expect { described_class.call(user, {}).result }.to raise_error(CustomException, "Unable to import contacts from file")
      expect { described_class.call(user, wrong_params).result }.to raise_error(CustomException, "Unable to import contacts from file")
      expect { described_class.call(user, (valid_params.except :file_csv)).result }.to raise_error(CustomException, "Unable to import contacts from file")
    end
  end

  context "when valid parameters are passed" do
    it "saves uploaded file" do
      expect(uploaded_file.present?).to eq(true)
      expect(uploaded_file.csv_file.attached?).to eq(true)
      expect(uploaded_file.csv_file.content_type).to include("text/csv")
      expect(uploaded_file.user.present?).to eq(true)
      expect(uploaded_file.status).to include("waiting")
      expect(uploaded_file.filename).to include(csv_file.original_filename)
    end
  end
end
