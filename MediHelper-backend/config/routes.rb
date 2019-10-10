Rails.application.routes.draw do
  resources :medications
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/get-medications', to: "medications#get_medications_list_by_search_term"
  post '/get-contraindications', to: "medications#check_for_contraindications"
end
