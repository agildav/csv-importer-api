require 'rails_helper'

RSpec.describe BadContactService::IndexBadContact, type: :service do
  let(:user) { create(:user) }
  let(:bad_contact) { create(:bad_contact) }

  context "when there are no contacts" do
    it "returns no contacts" do
      expect(described_class.call(user, nil).result).to be_empty
    end
  end

  context "when there are contacts" do
    it "returns a list of contacts" do
      expect(described_class.call(bad_contact.user, nil).result).to contain_exactly(bad_contact)
    end
  end
end