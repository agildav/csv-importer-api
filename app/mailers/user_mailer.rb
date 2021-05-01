class UserMailer < ApplicationMailer
  def file_status_email
    @uploaded_file = params[:uploaded_file]
    @user = @uploaded_file.user
    mail(to: @user.email, subject: 'File uploaded!')
  end
end
