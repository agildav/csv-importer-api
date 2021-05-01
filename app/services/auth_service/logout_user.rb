module AuthService
 class LogoutUser
    prepend SimpleCommand

    attr_accessor :user

    def initialize(user = nil)
      @user = user
    end

    def call
      user.token = nil
      user.save!
    end
  end
end
