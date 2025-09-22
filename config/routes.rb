Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :sign_up
  
  root "students#index"

  resources :students
  resources :reports

  namespace :settings do
    resource :password, only: [ :show, :update ]
  end

end
