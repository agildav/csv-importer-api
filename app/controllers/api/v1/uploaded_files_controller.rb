class Api::V1::UploadedFilesController < ApplicationController
  before_action :authenticate!

  def index
    uploaded_files, meta = paginate_resources UploadedFileService::IndexUploadedFile.call(@current_user, index_params).result
    render_response([uploaded_files, meta], UploadedFileSerializer, :ok)
  end

  private

  def index_params
    merge_with_page_params []
  end
end
