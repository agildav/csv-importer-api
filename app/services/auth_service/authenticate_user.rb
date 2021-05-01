module AuthService
 class AuthenticateUser
    prepend SimpleCommand

    attr_accessor :token
    attr_reader :auth_header

    def initialize(auth_header = nil)
      @auth_header = auth_header
    end

    def call
      check_header
      set_token
      find_user_by_token
    end

    private

    def check_header
      raise UnauthorizedException.new("No authorization header") if auth_header.blank?
    end

    def set_token
      @token = auth_header.split("Bearer ")&.second
      raise UnauthorizedException.new("No token") if token.blank?
    end

    def find_user_by_token
      user = User.find_by(token: token.squish)
      raise UnauthorizedException.new("Invalid token") if user.blank?
      user
    end
  end
end
