class ValidDatesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      Date.iso8601(String(value))
    rescue => exception
      record.errors[attribute] << (options[:message] || "invalid date format")
    end
  end
end
