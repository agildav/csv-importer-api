class EncryptedField
  def load(value)
    return if (value.blank? || value.include?("error: invalid credit card"))
    Marshal.load(SecureCrypt.decrypt_value(Base64.decode64(value)))
  end

  def dump(value)
    return if (value.blank? || value.include?("error: invalid credit card"))
    Base64.encode64(SecureCrypt.encrypt_value(Marshal.dump(value)))
  end
end