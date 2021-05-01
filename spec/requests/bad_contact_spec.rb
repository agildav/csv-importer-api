require 'rails_helper'

RSpec.describe "BadContact", type: :request do
  before(:all) do
    @bad_contact = create(:bad_contact)
    user = @bad_contact.user
    @user_password = user.password
    @user = AuthService::LoginUser.call(email: user.email, password: @user_password).result
  end

  describe "GET /api/v1/bad_contacts" do
    context "unauthenticated user" do
      it "returns unauthorized" do
        get '/api/v1/bad_contacts'
        expect(response).to have_http_status(401)
      end
    end

    context "authenticated user" do
      before { authenticate_user(@user) }

      it "returns bad contacts" do
        get '/api/v1/bad_contacts'
        bad_contacts_response = json_response

        expect(response).to have_http_status(200)
        expect(bad_contacts_response[:data].first[:user_id]).to eq(@user.id)
        expect(bad_contacts_response[:data].size).to be_between(1, 10)
        expect(bad_contacts_response[:meta][:total_resources]).to be > 0
      end
    end
  end
end
