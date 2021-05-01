require 'rails_helper'

RSpec.describe UploadedFileService::IndexUploadedFile, type: :service do
  let(:user) { create(:user) }
  let(:uploaded_file) { create(:uploaded_file, :with_attachment) }

  context "when there are no uploaded files" do
    it "returns no uploaded files" do
      expect(described_class.call(user, nil).result).to be_empty
    end
  end

  context "when there are uploaded files" do
    it "returns a list of uploaded files" do
      expect(described_class.call(uploaded_file.user, nil).result).to contain_exactly(uploaded_file)
    end
  end
end