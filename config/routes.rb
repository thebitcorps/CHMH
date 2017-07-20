Rails.application.routes.draw do
  devise_for :users
  post 'examined/create'
  get 'examined/not_examined'
  delete 'examined/destroy'
  get 'dashboard/index'
  get 'dashboard/monthly'
  get 'dashboard/chart'
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
  resources :users do
    get :chart
  end
  root to: "visitors#index"
end
