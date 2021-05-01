require 'rails_helper'

RSpec.describe AuthService::RegisterUser, type: :service do
  let(:user) { create(:user) }
  let(:fake_email) { Faker::Internet.email }
  let(:fake_password) { Faker::Alphanumeric.alphanumeric(number: 5) }

  context "when user credentials already exists" do
    it "does not register" do
      expect { described_class.call(email: user.email, password: nil) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { described_class.call(email: nil, password: user.password) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { described_class.call(email: user.email, password: user.password) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "when invalid credentials are passed" do
    it "does not register" do
      expect { described_class.call(email: fake_email, password: nil) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { described_class.call(email: nil, password: fake_password) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "when valid credentials are passed" do
    it "registers" do
      registered_user = described_class.call(email: fake_email, password: fake_password).result
      expect(registered_user.token.present?).to eq(true)
      expect(registered_user.authenticate(fake_password).present?).to eq(true)
    end
  end
end
