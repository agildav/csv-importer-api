module ContactService
  class ImportContact
    prepend SimpleCommand

    attr_reader :user, :params

    def initialize(user = nil, params = {})
      @user = user
      @params = params
    end

    def call
      save_file_in_transaction
    end

    private

    def save_file_in_transaction
      transaction_failed = false
      uploaded_file = nil

      ActiveRecord::Base.transaction do
        begin
          uploaded_file = save_file(user, params[:file_csv])
          attachment_path = get_attachment_path(uploaded_file)
          ImportCsvContactsJob.perform_later(user.id, (params.except :file_csv), uploaded_file, attachment_path)
        rescue => exception
          Rails.logger.error(exception)
          transaction_failed = true
          raise ActiveRecord::Rollback
        end
      end

      if transaction_failed
        raise CustomException.new("Unable to import contacts from file", "import")
      end

      uploaded_file
    end

    def save_file(user, file)
      raise CustomException.new("Missing CSV file", "import") if file.blank?
      UploadedFile.create!({
        status: "waiting",
        user: user,
        filename: file.original_filename,
        csv_file: file
      })
    end

    def get_attachment_path(uploaded_file)
      return if Rails.env.test?

      uploaded_file.csv_file.attachment.service_url
    end
  end
end
