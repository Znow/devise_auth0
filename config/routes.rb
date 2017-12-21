Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # home page
  root 'public_pages#home'
  
  # Dashboard
  get 'dashboard' => 'dashboard#show'

end