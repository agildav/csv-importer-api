module Request
  module JsonHelpers
    def json_response
      @json_response ||= parse_json(response)
    end

    private

    def parse_json(response = nil)
      raise "No response" if response.blank?

      if response.body.blank?
        return {}
      else
        return JSON.parse(response.body).with_indifferent_access
      end
    end
  end

  module AuthHelpers
    def authenticate_user(user = nil)
      expect(AuthService::AuthenticateUser).to receive(:call).and_return(double(result: user))
    end
  end
end
