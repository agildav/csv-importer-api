module AuthService
 class RegisterUser
    prepend SimpleCommand

    attr_accessor :user
    attr_reader :credentials

    def initialize(credentials = {})
      @credentials = credentials
    end

    def call
      create_user
      AuthService.save_tokens(user)
    end

    private

    def create_user
      @user = User.new(credentials)
      raise ActiveRecord::RecordInvalid.new(user) unless user.valid?
      user
    end
  end
end
