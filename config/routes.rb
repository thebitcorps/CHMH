Rails.application.routes.draw do
  resources :task_procedures

  resources :procedures

  resources :tasks

  resources :surgeries
  resources :seasons
  resources :areas


  root :to => "visitors#index"
  devise_for :users
  resources :users

end
