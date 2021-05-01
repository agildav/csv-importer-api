class AuthSerializer < ActiveModel::Serializer
  attributes [
    :id,
    :email,
    :token,
    :created_at
  ]

end
