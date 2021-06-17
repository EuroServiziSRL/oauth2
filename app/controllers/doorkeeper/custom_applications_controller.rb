module Doorkeeper
    class CustomApplicationsController < ApplicationsController
        layout 'doorkeeper/admin' unless Doorkeeper.configuration.api_only
    
        #before_action :authenticate_admin!, only: [] #da abilitare in localhost
        before_action :authenticate_admin!, except: [:get_info_cid] #da abilitare in prod
        before_action :set_application, only: %i[show edit update destroy]
    
        #Controllo di avere un parametro jwt e di poterlo decodificare
        def authenticate_admin!
          jwt = params[:jwt] || session['auth']
          unless jwt.blank?
            begin
              hash_token_decoded = JsonWebToken.decode(jwt) 
              #verifico istante temporale
              unless JsonWebToken.valid_token(hash_token_decoded)
                redirect_to auth_mancante_path
              end
              session['auth'] = jwt
            rescue => exc
              logger.error "Oauth2: Problemi decodifica jwt per autenticazione: "+exc.message
              logger.error exc.backtrace.join("\n")
              redirect_to auth_mancante_path
            end
          else
            redirect_to auth_mancante_path
          end

        end


        def index
            if params['demo_mode'] == 'true'
              @applications = Application.where(demo_site: true).ordered_by(:created_at)
            else
              if request.format.to_s == "application/json" #caso app che mostra solo enti non di demo
                @applications = Application.where(demo_site: [nil, false]).ordered_by(:created_at)
              else #caso da web che vede tutti
                @applications = Application.all.ordered_by(:created_at)
              end
            end
            respond_to do |format|
                format.html
                format.json { render json: @applications }
            end
        end
    
        def show
          respond_to do |format|
            format.html
            format.json { render json: @application }
          end
        end
    
        def new
          @application = Application.new
        end
    
        def create
          @application = Application.new(application_params)
    
          if @application.save
            flash[:notice] = I18n.t(:notice, scope: %i[doorkeeper flash applications create])
    
            respond_to do |format|
              format.html { redirect_to oauth_application_url(@application) }
              format.json { render json: @application }
            end
          else
            respond_to do |format|
              format.html { render :new }
              format.json { render json: { errors: @application.errors.full_messages }, status: :unprocessable_entity }
            end
          end
        end
    
        def edit; end
    
        def update
          if @application.update(application_params)
            flash[:notice] = I18n.t(:notice, scope: %i[doorkeeper flash applications update])
    
            respond_to do |format|
              format.html { redirect_to oauth_application_url(@application) }
              format.json { render json: @application }
            end
          else
            respond_to do |format|
              format.html { render :edit }
              format.json { render json: { errors: @application.errors.full_messages }, status: :unprocessable_entity }
            end
          end
        end
    
        def destroy
          flash[:notice] = I18n.t(:notice, scope: %i[doorkeeper flash applications destroy]) if @application.destroy
    
          respond_to do |format|
            format.html { redirect_to oauth_applications_url }
            format.json { head :no_content }
          end
        end
    
        #ritorna le info dell'ente
        def get_info_cid
          hash_params = params.permit!
          app_ente_info = {}
          c_id = hash_params[:cid]
          qs_app_ente = Application.where(uid: c_id)
          unless qs_app_ente.blank?
            #popolo hash 
            app_ente = qs_app_ente[0]
            app_ente_info[:client_id] = c_id
            app_ente_info[:nome_ente] = app_ente.name
            app_ente_info[:url_ente] = app_ente.portal_url 
          end
          
          respond_to do |format|
            #format.html { render app_ente_info }
            format.json { render json: app_ente_info.to_json }
          end
          

        end


        private
    
        def set_application
          @application = Application.find(params[:id])
        end

        def application_params
          params.require(:doorkeeper_application).permit(:name, :redirect_uri, :scopes, :confidential, :image_url, :tipo_login, :portal_url, :extra_info, :demo_site, :mobile_app, :demo_mode)
        end
    end

end