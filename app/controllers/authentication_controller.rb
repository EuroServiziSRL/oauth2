class AuthenticationController < ApplicationController
  
  #form di login, ho parametro in sessione per redirect url e client id
  def new
    unless session[:client_id].blank?
      applicazione = Doorkeeper::Application.find_by uid: session[:client_id]
      if applicazione.blank?
        @errore = "Login non permesso!"
      else
        @nome_ente = applicazione.name
        @redirect_uri = applicazione.redirect_uri
        @image_url = applicazione.image_url
      end
    else
      @errore = "Login non permesso!"
    end
  
  end

  #arriva il post da form login react con csrf token
  #params['data']
  #{"stato"=>"ok", "sid_sessione"=>"3f3a597a-325c-40eb-81c2-544a0bee9d78", 
  #"dati_utente"=>{"nome"=>"Andrea", "cognome"=>"Grazian", "codice_fiscale"=>"BRRRRT68L71B300L", "id"=>1}, "servizi_privati"=>[]} 
  def create
    if params['data'].blank? || params['data']['dati_utente'].blank?
      msg = { :stato => "ko", :messaggio => "Dati Mancanti" }
    else
      #carico l'applicazione dal client_id in sessione
      app = Doorkeeper::Application.find_by(uid: session[:client_id])
      session['user'] = params['data']['dati_utente']
      session['user']['sid_sessione'] = params['data']['sid_sessione']
      session['user']['application_id'] = app.id unless app.blank?
      msg = { :stato => "ok", :messaggio => "Login Effettuato!" }
    end
    respond_to do |format|
      format.json  { render json: msg } 
    end
  end

end
