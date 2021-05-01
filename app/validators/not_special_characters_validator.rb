class NotSpecialCharactersValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    special_characters_regex = /\A([0-9a-zA-Z\-\s])+\z/

    unless value =~ special_characters_regex
      record.errors[attribute] << (options[:message] || "invalid format")
    end
  end
end
