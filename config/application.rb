require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Oes
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :it
  
    #CORS
    #allow GET, POST or OPTIONS requests from any origin on any resource.
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end
  
    config.to_prepare do
      # # Only Applications list
      # Doorkeeper::ApplicationsController.layout "doorkeeper/test_layout"
    
      # # Only Authorization endpoint
      # Doorkeeper::AuthorizationsController.layout "doorkeeper/test_layout"
    
      # # Only Authorized Applications
      # Doorkeeper::AuthorizedApplicationsController.layout "doorkeeper/test_layout"
      
      # include only the ApplicationHelper module
      Doorkeeper::ApplicationController.helper ApplicationHelper
    
      # include all helpers from your application
      Doorkeeper::ApplicationController.helper Oes::Application.helpers
      
    end
  
    config.autoload_paths << "#{Rails.root}/lib"
  
  end
end
