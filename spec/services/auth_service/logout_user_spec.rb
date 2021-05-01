require 'rails_helper'

RSpec.describe AuthService::LogoutUser, type: :service do
  let(:user) { create(:user) }

  context "when logged in" do
    it "logouts" do
      user[:token] = Faker::Lorem.word
      expect(user.token.present?).to eq(true)

      expect { described_class.call(user) }.not_to raise_error
      expect(user.token.present?).to eq(false)
    end
  end

  context "when logged out" do
    it "logouts" do
      expect(user.token.present?).to eq(false)

      expect { described_class.call(user) }.not_to raise_error
      expect(user.token.present?).to eq(false)
    end
  end
end
