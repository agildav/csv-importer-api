module ContactService
  class ProcessFile
    prepend SimpleCommand
    require 'csv'

    attr_accessor :uploaded_file
    attr_reader :curr_user_id, :params, :attachment_path

    def initialize(curr_user_id = nil, params = {}, uploaded_file = nil, attachment_path = nil)
      @curr_user_id = curr_user_id
      @params = params
      @uploaded_file = uploaded_file
      @attachment_path = attachment_path
    end

    def call
      uploaded_file.status = "processing"
      uploaded_file.save!

      import_contacts_in_transaction
    end

    private

    def import_contacts_in_transaction
      transaction_failed = false

      ActiveRecord::Base.transaction do
        begin
          keys_mapping = generate_keys_mapping(params)
          file = get_file_from_path(attachment_path, curr_user_id)

          valid_contacts, invalid_contacts = load_contacts_from_file(file, curr_user_id, uploaded_file, keys_mapping)
          possible_bad_contacts = get_possible_bad_contacts(invalid_contacts)

          import_contacts(valid_contacts, invalid_contacts, uploaded_file)
          import_bad_contacts(possible_bad_contacts)
        rescue => exception
          Rails.logger.error(exception)
          transaction_failed = true
          raise ActiveRecord::Rollback
        end
      end

      if transaction_failed
        uploaded_file.status = "failed"
        uploaded_file.save!
        send_upload_file_status_email(uploaded_file)
        raise CustomException.new("Unable to import contacts from file", "import")
      end

      send_upload_file_status_email(uploaded_file)
      uploaded_file
    end

    def generate_keys_mapping(params)
      keys = (Contact.column_names - Contact::PROTECTED_ATTRIBUTES) || []
      keys_mapping = {}

      # match custom names for standard fields
      (keys.map(&:to_sym)).each do |key|
        if params.key? key
          keys_mapping[params[key]] = key
        end
      end

      keys_mapping
    end

    def get_file_from_path(attachment_path, curr_user_id)
      return FilesTestHelper.csv if Rails.env.test?

      download_file(attachment_path, curr_user_id)
    end

    def load_contacts_from_file(file, user_id, uploaded_file, keys_mapping)
      valid_contacts = []
      invalid_contacts = []

      CSV.foreach(file, :headers => true) do |row|
        row_size = row.size
        new_contact = Contact.new({
          user_id: user_id,
          uploaded_file: uploaded_file
        })

        (0...row_size).each do |index|
          field = keys_mapping[(row.headers[index]).squish_downcase]
          new_contact.send("#{field}=", (row[index])&.squish_downcase)
        end

        if new_contact.valid?
          valid_contacts << new_contact
        else
          invalid_contacts << new_contact
        end
      end

      [valid_contacts, invalid_contacts]
    end

    def get_possible_bad_contacts(invalid_contacts)
      possible_bad_contacts = []
      invalid_contacts.each do |invalid_contact|
        bad_contact = BadContact.new
        invalid_contact.attributes.keys.each do |key|
          bad_contact.send("#{key}=", invalid_contact.send(key))
          possible_error = invalid_contact.errors[key.to_sym]&.last

          if possible_error.present?
            bad_contact.send("#{key}=", ("error: " + possible_error))
          end
        end

        possible_bad_contacts << bad_contact
      end

      possible_bad_contacts
    end

    def import_contacts(valid_contacts, invalid_contacts, uploaded_file)
      if valid_contacts.blank?
        # did not save at least 1 contact
        if invalid_contacts.size > 0
          uploaded_file.status = "failed"
        else
          uploaded_file.status = "done"
        end
      else
        Contact.import(valid_contacts)
        uploaded_file.status = "done"
      end

      uploaded_file.save!
    end

    def import_bad_contacts(possible_bad_contacts)
      BadContact.import(possible_bad_contacts) unless possible_bad_contacts.blank?
    end

    def save_to_tempfile(url, tempfile_name = "")
      tempfile_name = String(tempfile_name) + Time.current.strftime("%y%m%d%s")
      # Set up the temp file:
      file = Tempfile.new([tempfile_name, '.csv'])

      #Make the curl request:
      curlString = "curl --silent -X GET \"#{url}\" -o \"#{file.path}\""
      curlRequest = `#{curlString}`
      file.close
      file
    end

    def download_file(file_path, name = nil)
      save_to_tempfile(file_path, name)
    end

    def send_upload_file_status_email(uploaded_file)
      UserMailer.with(uploaded_file: uploaded_file).file_status_email.deliver_later
    end
  end
end
