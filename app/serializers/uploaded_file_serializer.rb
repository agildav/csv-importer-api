class UploadedFileSerializer < ActiveModel::Serializer
  attributes [
    :id,
    :filename,
    :status,
    :file_url,
    :created_at
  ]

  def file_url
    object.csv_file.attachment.service_url
  end
end
