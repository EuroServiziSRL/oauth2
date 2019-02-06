Rails.application.routes.draw do
  
  
  use_doorkeeper_openid_connect
  use_doorkeeper
  
  root to: "pages#root"
  get 'authentication/new'
  get 'authentication/create'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
