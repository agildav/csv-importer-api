module UploadedFileService
  class IndexUploadedFile
     prepend SimpleCommand

     attr_reader :user, :params

     def initialize(user = nil, params = {})
       @user = user
       @params = params
     end

     def call
      UploadedFile.includes([csv_file_attachment: [:blob]]).where(user: user).order(created_at: :desc)
     end
  end
end
