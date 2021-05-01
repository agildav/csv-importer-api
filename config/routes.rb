Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      # AUTH
      scope :auth, controller: 'auth', constraints: { id: /[0-9]+/ } do
        get "validate/token", to: "auth#validate_token"
        post "register", to: "auth#register"
        post "login", to: "auth#login"
        delete "logout", to: "auth#logout"
      end

      # CONTACTS
      resources :contacts, controller: 'contacts', only: [:index], constraints: { id: /[0-9]+/, user_id: /[0-9]+/ } do
        collection do
          post "import", to: "contacts#import_contacts"
        end
      end

      # BAD CONTACTS
      resources :bad_contacts, controller: 'bad_contacts', only: [:index], constraints: { id: /[0-9]+/, user_id: /[0-9]+/ } do
      end

      # UPLOADED FILES
      resources :uploaded_files, controller: 'uploaded_files', only: [:index], constraints: { id: /[0-9]+/, user_id: /[0-9]+/ } do
      end
    end
  end
end
