require 'rails_helper'

RSpec.describe ContactService::IndexContact, type: :service do
  let(:user) { create(:user) }
  let(:contact) { create(:contact) }
  let(:csv_file) { FilesTestHelper.csv }

  context "when there are no contacts" do
    it "returns no contacts" do
      expect(described_class.call(user, nil).result).to be_empty
    end
  end

  context "when there are contacts" do
    it "returns a list of contacts" do
      expect(described_class.call(contact.user, nil).result).to contain_exactly(contact)
    end
  end
end
