class ValidPhonesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    phone_regex_one = /\A\(\+[0-9]{2}\)\s[0-9]{3}\s[0-9]{3}\s[0-9]{2}\s[0-9]{2}\z/
    phone_regex_two = /\A\(\+[0-9]{2}\)\s[0-9]{3}\-[0-9]{3}\-[0-9]{2}\-[0-9]{2}\z/

    valid = (value =~ phone_regex_one || value =~ phone_regex_two)
    unless valid
      record.errors[attribute] << (options[:message] || "invalid phone number")
    end
  end
end