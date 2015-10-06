Rails.application.routes.draw do
  post 'examined/create'
  get 'examined/not_examined'
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

  resources :surgeries do
    get :query, on: :member
  end


  resources :seasons
  resources :areas


  root :to => "visitors#index"
  devise_for :users
  resources :users

end
