class ImportCsvContactsJob < ApplicationJob
  queue_as :default

  def perform(curr_user_id, params, uploaded_file, attachment_path)
    ContactService::ProcessFile.call(curr_user_id, params, uploaded_file, attachment_path).result
  end
end
