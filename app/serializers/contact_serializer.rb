class ContactSerializer < ActiveModel::Serializer
  attributes [
    :id,
    :name,
    :email,
    :address,
    :birth_date,
    :credit_card,
    :franchise,
    :phone,
    :user_id,
    :file,
    :created_at
  ]

  def credit_card
    cc = object.credit_card
    error = "error: invalid credit card"
    return error if (cc.blank? || cc.include?(error))

    "****" + cc.chars.last(4).join("")
  end

  def franchise
    cc = object.credit_card || ""
    cc_franchise = CreditCardValidator::Validator.card_type(cc)
    return if cc_franchise.blank?

    return cc_franchise
  end

  def file
    object.uploaded_file
  end
end
