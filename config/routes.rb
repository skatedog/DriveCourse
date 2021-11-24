Rails.application.routes.draw do
  devise_for :users
  root "homes#top"
  get "homes/search"
  resources :places, only: [:index, :create, :destroy]
  resources :users, except: [:index, :new, :create]
  resources :vehicles, except: [:index, :show]
  resources :courses do
    patch :record, on: :member
    post :import, on: :member
    resource :course_likes, only: [:create, :destroy]
    resources :spots, only: [:edit, :update, :create, :destroy] do
      post :import, on: :member
      resource :spot_likes, only: [:create, :destroy]
    end
  end
end
