Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    root "devise/sessions#new"
  end
  resources :users, except: [:new, :create] do
    resources :vehicles, except: :index
    resources :places
  end
end
