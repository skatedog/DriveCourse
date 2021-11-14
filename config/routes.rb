Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    root "devise/sessions#new"
  end
  resources :places
  resources :users, except: [:new, :create] do
    resources :vehicles, except: :index
    resources :courses do
      resources :spots, only: [:create, :destroy]
    end
  end
end
