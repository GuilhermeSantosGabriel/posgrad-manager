Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  resources :students
  resources :reports
  resources :professors
  resources :administrators
  
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  
  resources :users
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "student_home", to: "students#home", as: "student_home"
  get "professor_home", to: "professors#home", as: "professor_home"
  post :change_professor, to: "students#change_professor"


  authenticated :user do
    root to: "pages#home", as: :authenticated_user_root
  end

  root "pages#home"
  # Defines the root path route ("/")
  # root "posts#index"
end
