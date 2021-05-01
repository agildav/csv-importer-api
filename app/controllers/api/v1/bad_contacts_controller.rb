class Api::V1::BadContactsController < ApplicationController
  before_action :authenticate!

  def index
    bad_contacts, meta = paginate_resources BadContactService::IndexBadContact.call(@current_user, index_params).result
    render_response([bad_contacts, meta], ContactSerializer, :ok)
  end

  private

  def index_params
    merge_with_page_params []
  end
end
