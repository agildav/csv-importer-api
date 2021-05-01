require 'rails_helper'

RSpec.describe "Contact", type: :request do
  before(:all) do
    @file_csv = FilesTestHelper.csv
    @contact = create(:contact)
    user = @contact.user
    @user_password = user.password
    @user = AuthService::LoginUser.call(email: user.email, password: @user_password).result
  end

  describe "GET /api/v1/contacts" do
    context "unauthenticated user" do
      it "returns unauthorized" do
        get '/api/v1/contacts'
        expect(response).to have_http_status(401)
      end
    end

    context "authenticated user" do
      before { authenticate_user(@user) }

      it "returns contacts" do
        get '/api/v1/contacts'
        contacts_response = json_response

        expect(response).to have_http_status(200)
        expect(contacts_response[:data].first[:user_id]).to eq(@user.id)
        expect(contacts_response[:data].size).to be_between(1, 10)
        expect(contacts_response[:meta][:total_resources]).to be > 0
      end
    end
  end

  describe "POST /api/v1/contacts/import" do
    before { authenticate_user(@user) }

    context "invalid parameters does not import contacts" do
      it do
        post '/api/v1/contacts/import',
          params: {
            contact: {
              address: "address",
              birth_date: "birth_date",
              credit_card: "credit_card",
              email: "email",
              name: "name",
              phone: "phone"
            }, file_csv: nil
          }
        expect(response).to have_http_status(422)
      end
    end

    context "valid parameters" do
      it "imports contacts" do
        post '/api/v1/contacts/import',
        params: {
          contact: {
            address: "address",
            birth_date: "birth_date",
            credit_card: "credit_card",
            email: "email",
            name: "name",
            phone: "phone"
          }, file_csv: @file_csv
        }
        contact_response = json_response[:data]

        expect(response).to have_http_status(200)
        expect(contact_response[:id]).to be > 0
        expect(contact_response[:status]).to include("waiting")
        expect(contact_response[:filename]).to include(@file_csv.original_filename)
      end
    end
  end
end
