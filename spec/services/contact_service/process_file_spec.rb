require 'rails_helper'

RSpec.describe ContactService::ProcessFile, type: :service do
  let(:user) { create(:user) }
  let(:csv_file) { FilesTestHelper.csv }
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
  let(:uploaded_file) { ContactService::ImportContact.call(user, valid_params).result }
  let(:processed_uploaded_file) { described_class.call(uploaded_file.user.id, valid_params, uploaded_file, nil).result }

  context "when uploaded file is saved" do
    it "import contacts" do
      expect(processed_uploaded_file.status).to include("done")
      expect(processed_uploaded_file.filename).to include(csv_file.original_filename)
      expect(Contact.count).to be(2)
      expect(BadContact.count).to be(4)
    end
  end
end
