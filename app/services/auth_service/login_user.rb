module AuthService
 class LoginUser
    prepend SimpleCommand

    attr_accessor :user
    attr_reader :email, :password

    def initialize(credentials = {})
      @email = credentials[:email]
      @password = credentials[:password]
    end

    def call
      find_user
      authenticate_user
      AuthService.save_tokens(user)
    end

    private

    def find_user
      @user = User.find_by("lower(email) = ?", email.squish_downcase) if email.present?
      raise UnauthorizedException.new("Invalid credentials") if user.blank?
      user
    end

    def authenticate_user
      raise UnauthorizedException.new("Invalid credentials") if user.authenticate(password).blank?
    end
  end
end
