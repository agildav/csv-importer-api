require 'rails_helper'

RSpec.describe "UploadedFile", type: :request do
  before(:all) do
    @uploaded_file = create(:uploaded_file, :with_attachment)
    user = @uploaded_file.user
    @user_password = user.password
    @user = AuthService::LoginUser.call(email: user.email, password: @user_password).result
  end

  describe "GET /api/v1/uploaded_files" do
    context "unauthenticated user" do
      it "returns unauthorized" do
        get '/api/v1/uploaded_files'
        expect(response).to have_http_status(401)
      end
    end

    context "authenticated user" do
      before { authenticate_user(@user) }

      it "returns uploaded files" do
        get '/api/v1/uploaded_files'
        uploaded_files_response = json_response

        expect(response).to have_http_status(200)
        expect(uploaded_files_response[:data].size).to be_between(1, 10)
        expect(uploaded_files_response[:meta][:total_resources]).to be > 0
      end
    end
  end
end
