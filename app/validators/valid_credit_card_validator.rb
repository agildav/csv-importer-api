class ValidCreditCardValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    CreditCardValidator::Validator.options[:allowed_card_types] = [:amex, :discover, :diners_club, :master_card, :visa, :maestro, :jcb]

    unless CreditCardValidator::Validator.valid?(String(value).squish_downcase)
      record.errors[attribute] << (options[:message] || "invalid credit card")
    end
  end
end
