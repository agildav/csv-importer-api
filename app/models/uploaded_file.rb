# == Schema Information
#
# Table name: uploaded_files
#
#  id         :bigint           not null, primary key
#  filename   :string           not null
#  status     :integer          default("waiting"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_uploaded_files_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class UploadedFile < ApplicationRecord
  has_one_attached :csv_file

  belongs_to :user
  has_many :contacts
  has_many :bad_contacts

  validates :user, presence: true
  validates :filename, presence: true
  validates :status, presence: true
  validate :valid_csv

  enum status: { waiting: 0, processing: 1, failed: 2, done: 3 }

  def valid_csv
    return unless csv_file.attached?

    acceptable_types = ["text/csv"]
    unless acceptable_types.include?(csv_file.content_type)
      errors.add(:csv_file, "must be a CSV file")
    end
  end
end
