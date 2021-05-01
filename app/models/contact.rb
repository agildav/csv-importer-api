# == Schema Information
#
# Table name: contacts
#
#  id               :bigint           not null, primary key
#  address          :string           not null
#  birth_date       :date             not null
#  credit_card      :string           not null
#  email            :string           not null
#  name             :string           not null
#  phone            :string           not null
#  tsv              :tsvector
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  uploaded_file_id :bigint
#  user_id          :bigint
#
# Indexes
#
#  index_contacts_on_tsv               (tsv) USING gin
#  index_contacts_on_uploaded_file_id  (uploaded_file_id)
#  index_contacts_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (uploaded_file_id => uploaded_files.id)
#  fk_rails_...  (user_id => users.id)
#
class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :uploaded_file

  validates :user_id, presence: true
  validates :uploaded_file_id, presence: true
  validates :email, presence: true
  validates :email, uniqueness: { scope: [:user_id] }

  validates :name, presence: true, not_special_characters: true
  validates :birth_date, presence: true, valid_dates: true
  validates :address, presence: true
  validates :credit_card, presence: true, valid_credit_card: true
  validates :phone, presence: true, valid_phones: true

  serialize :credit_card, EncryptedField.new

  include PgSearch::Model
  pg_search_scope :search_by_name,
                  against: :name,
                  using: {
                    tsearch: { tsvector_column: "tsv", prefix: true }
                  },
                  ignoring: :accents

  PROTECTED_ATTRIBUTES = ["id", "user_id", "uploaded_file_id", "tsv", "created_at", "updated_at"]
end
