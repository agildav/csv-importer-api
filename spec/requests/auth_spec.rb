require 'rails_helper'

RSpec.describe "Auth", type: :request do
  before(:all) do
    user = create(:user)
    @user_password = user.password
    @user = AuthService::LoginUser.call(email: user.email, password: @user_password).result
    @email = Faker::Internet.email
    @password = Faker::JapaneseMedia::SwordArtOnline.game_name.first(5)
  end

  describe "GET /api/v1/auth/validate/token" do
    context "invalid credentials returns error" do
      it { get '/api/v1/auth/validate/token' }
      it { get '/api/v1/auth/validate/token', headers: { 'HTTP_AUTHORIZATION' => "" } }
      it { get '/api/v1/auth/validate/token', headers: { 'HTTP_AUTHORIZATION' => "Bearer " } }
      it { get '/api/v1/auth/validate/token', headers: { 'HTTP_AUTHORIZATION' => "Bearer invalid_token" } }

      after do
        expect(response).to have_http_status(401)
      end
    end

    context "valid credentials" do
      before { authenticate_user(@user) }

      it "returns current user" do
        get '/api/v1/auth/validate/token'
        user_response = json_response[:data]

        expect(response).to have_http_status(200)
        expect(user_response[:id]).to eq(@user.id)
        expect(user_response[:email]).to eq(@user.email)
      end
    end
  end

  describe "POST /api/v1/auth/register" do
    context "invalid credentials" do
      it "does not register a user" do
        post '/api/v1/auth/register'
        expect(response).to have_http_status(400)
      end
    end

    context "existing credentials" do
      it "does not register a user" do
        post '/api/v1/auth/register',
          params: { user: { email: @user.email, password: @password } }
        user_errors = json_response[:errors]

        expect(response).to have_http_status(422)
        expect(user_errors[:email]).to include("has already been taken")
      end
    end

    context "valid credentials" do
      it "registers a user" do
        post '/api/v1/auth/register',
          params: { user: { email: @email, password: @password } }
        user_response = json_response[:data]

        expect(response).to have_http_status(201)
        expect(user_response[:id]).to be > 0
        expect(user_response[:email]).to eq(@email)
        expect(user_response[:token]).not_to be_empty
      end
    end
  end

  describe "POST /api/v1/auth/login" do
    context "invalid credentials does not login a user" do
      let(:user_error) { json_response[:error] }

      it { post '/api/v1/auth/login', params: { user: { email: nil, password: @password } } }
      it { post '/api/v1/auth/login', params: { user: { email: @email, password: nil } } }
      it { post '/api/v1/auth/login', params: { user: { email: @email, password: @password } } }

      after do
        expect(response).to have_http_status(401)
        expect(user_error).to include("Invalid credentials")
      end
    end

    context "valid credentials" do
      it "logs in a user" do
        post '/api/v1/auth/login',
          params: { user: { email: @user.email, password: @user_password } }
        user_response = json_response[:data]

        expect(response).to have_http_status(200)
        expect(user_response[:id]).to eq(@user.id)
        expect(user_response[:email]).to eq(@user.email)
        expect(user_response[:token]).not_to be_empty
      end
    end
  end

  describe "DELETE /api/v1/auth/logout" do
    context "as unauthenticated user" do
      it "does not logout" do
        delete '/api/v1/auth/logout'
        expect(response).to have_http_status(401)
      end
    end

    context "as authenticated user" do
      before { authenticate_user(@user) }

      it "logouts" do
        delete '/api/v1/auth/logout'
        user_response = json_response

        expect(response).to have_http_status(204)
        expect(user_response).to be_empty
      end
    end
  end
end
