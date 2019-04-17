module Doorkeeper
    class CustomApplicationsController < ApplicationsController
        layout 'doorkeeper/admin' unless Doorkeeper.configuration.api_only
    
        before_action :authenticate_admin!
        before_action :set_application, only: %i[show edit update destroy]
    
        def index
            if params['demo_mode'] == 'true'
              @applications = Application.where(demo_site: true).ordered_by(:created_at)
            else
              @applications = Application.where(demo_site: [nil, false]).ordered_by(:created_at)
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
    
        private
    
        def set_application
          @application = Application.find(params[:id])
        end
    
        def application_params
          params.require(:doorkeeper_application)
            .permit(:name, :redirect_uri, :scopes, :confidential, :image_url, :tipo_login, :portal_url, :extra_info, :demo_site, :mobile_app, :demo_mode)
        end
    end

end