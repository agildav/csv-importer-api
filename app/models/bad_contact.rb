# == Schema Information
#
# Table name: bad_contacts
#
#  id               :bigint           not null, primary key
#  address          :string
#  birth_date       :string
#  credit_card      :string
#  email            :string
#  name             :string
#  phone            :string
#  tsv              :tsvector
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  uploaded_file_id :bigint
#  user_id          :bigint
#
# Indexes
#
#  index_bad_contacts_on_tsv               (tsv) USING gin
#  index_bad_contacts_on_uploaded_file_id  (uploaded_file_id)
#  index_bad_contacts_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (uploaded_file_id => uploaded_files.id)
#  fk_rails_...  (user_id => users.id)
#
class BadContact < ApplicationRecord
  belongs_to :user
  belongs_to :uploaded_file

  validates :user_id, presence: true
  validates :uploaded_file_id, presence: true

  serialize :credit_card, EncryptedField.new

  include PgSearch::Model
  pg_search_scope :search_by_name,
                  against: :name,
                  using: {
                    tsearch: { tsvector_column: "tsv", prefix: true }
                  },
                  ignoring: :accents
end
