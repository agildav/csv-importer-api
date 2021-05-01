module AuthService
  extend self

  def save_tokens(user)
    set_token(user)
    user.save!
    user
  end

  private

  def set_token(user)
    user.token = SecureRandom.urlsafe_base64(48)
  end
end
