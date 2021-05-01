# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  token           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_token  (token) UNIQUE
#
class User < ApplicationRecord
  has_secure_password

  has_many :contacts, dependent: :destroy
  has_many :bad_contacts, dependent: :destroy
  has_many :uploaded_files, dependent: :destroy

  validates :email, :password_digest, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :token, uniqueness: { case_sensitive: false }, allow_blank: true
end
