require 'rails_helper'

RSpec.describe AuthService::LoginUser, type: :service do
  let(:user) { create(:user) }
  let(:fake_email) { Faker::Internet.email }
  let(:fake_password) { Faker::Alphanumeric.alphanumeric(number: 5) }

  context "when invalid credentials are passed" do
    it "does not login" do
      expect { described_class.call(email: fake_email, password: user.password) }.to raise_error(UnauthorizedException, "Invalid credentials")
      expect { described_class.call(email: user.email, password: fake_password) }.to raise_error(UnauthorizedException, "Invalid credentials")
      expect { described_class.call(email: fake_email, password: fake_password) }.to raise_error(UnauthorizedException, "Invalid credentials")
    end
  end

  context "when valid credentials are passed" do
    it "logins" do
      expect(user.token.present?).to eq(false)
      logged_in_user = described_class.call(email: user.email, password: user.password).result
      expect(logged_in_user.token.present?).to eq(true)
      expect(logged_in_user.authenticate(user.password).present?).to eq(true)
      expect(logged_in_user.password_digest).not_to eq(user.password)
    end
  end
end
