module ContactService
  class IndexContact
     prepend SimpleCommand

     attr_reader :user, :params

     def initialize(user = nil, params = {})
       @user = user
       @params = params
     end

     def call
      Contact.includes([:uploaded_file]).where(user: user).order(created_at: :desc)
    end
  end
end