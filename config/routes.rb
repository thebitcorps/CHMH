Rails.application.routes.draw do
  post 'examined/create'

  delete 'examined/destroy'

  get 'dashboard/index'
  get 'dashboard/monthly'



  resources :task_procedures

  resources :procedures do
    collection do
      get :monthly
    end
  end

  resources :tasks

  resources :surgeries
  resources :seasons
  resources :areas


  root :to => "visitors#index"
  devise_for :users
  resources :users

end
