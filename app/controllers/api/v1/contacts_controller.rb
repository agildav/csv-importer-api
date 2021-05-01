class Api::V1::ContactsController < ApplicationController
  before_action :authenticate!

  def index
    contacts, meta = paginate_resources ContactService::IndexContact.call(@current_user, index_params).result
    render_response([contacts, meta], ContactSerializer, :ok)
  end

  def import_contacts
    render_response([ContactService::ImportContact.call(@current_user, import_contacts_params).result], UploadedFileSerializer, :ok)
  end

  private

  def index_params
    merge_with_page_params []
  end

  def import_contacts_params
    parse_multipart_form_data(:contact, [
      :address,
      :birth_date,
      :credit_card,
      :email,
      :name,
      :phone
    ], [:file_csv])
  end
end
