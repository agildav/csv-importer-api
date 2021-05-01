module FilesTestHelper
  extend self
  extend ActionDispatch::TestProcess

  def csv_name; 'test-csv-file.csv' end
  def csv; upload(csv_name, 'text/csv') end

  private

  def upload(name, type)
    file_path = Rails.root.join('spec', 'files', name)
    fixture_file_upload(file_path, type)
  end
end
