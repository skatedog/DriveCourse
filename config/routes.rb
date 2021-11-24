Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    root "devise/sessions#new"
  end
  get "homes/top"
  resources :places, only: [:index, :create, :destroy]
  resources :users, except: [:index, :new, :create]
  resources :vehicles, except: [:index, :show]
  resources :courses do
    patch :record, on: :member
    resource :course_likes, only: [:create, :destroy]
    resources :spots, only: [:edit, :update, :create, :destroy] do
      resource :spot_likes, only: [:create, :destroy]
    end
  end
end
