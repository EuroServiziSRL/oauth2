Rails.application.routes.draw do
  
  use_doorkeeper do
    # it accepts :authorizations, :tokens, :token_info, :applications and :authorized_applications
    #as :applications => 'custom_applications'
    controllers :applications => 'doorkeeper/custom_applications'
  end
  
  root to: "pages#root"
  get 'authentication/new'
  post 'authentication/create'
  #route per ritornare le info dell'ente da un client_id
  get '/oauth/application/get_info_cid/:cid', to: 'doorkeeper/custom_applications#get_info_cid', as: 'get_info_cid'

  get 'auth_mancante' => 'authentication#auth_mancante', :as => :auth_mancante
  
  
end
