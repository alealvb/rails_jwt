Rails.application.routes.draw do
  post 'auth/register', to: 'users#create'
  post 'auth/login', to: 'users#login'
  get 'user', to: 'users#show'
end
