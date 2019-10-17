Rails.application.routes.draw do
  resources :medications
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/get-medications', to: "medications#get_medications_list_by_search_term"
  post '/get-contraindications', to: "medications#check_for_contraindications"
  post '/get-users-medications', to: "medications#get_users_medications"
  post '/delete-medication', to: "medications#delete_medication"
  post '/change-medication-image', to: "medications#change_image"
end
