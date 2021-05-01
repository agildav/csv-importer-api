require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "file_status_email" do
    let(:uploaded_file) { create(:uploaded_file) }
    let(:mail) { described_class.with(uploaded_file: uploaded_file).file_status_email }

    it "renders the headers" do
      expect(mail.subject).to eq("File uploaded!")
      expect(mail.to).to eq([uploaded_file.user.email])
      expect(mail.from).to eq(["noreply@csvimporterapi.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("The final status of the process is:")
    end
  end
end
