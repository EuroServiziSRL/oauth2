require 'ostruct'


Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (needs plugins)
  orm :active_record

  # This block will be called to check whether the resource owner is authenticated or not.
  # resource_owner_authenticator do
  #   raise "Please configure doorkeeper resource_owner_authenticator block located in #{__FILE__}"
  #   # Put your resource owner authentication logic here.
  #   # Example implementation:
  #   #   User.find_by_id(session[:user_id]) || redirect_to(new_user_session_url)
  # end
  
  
  #Qui viene fatta l'autenticazione
  # 1 - 2 - 4
  #Arriva
  # {"client_id"=>"87256f9997efa4921aadd4caa1940134210d31b59f5685a2f3067d3de0e520fd", 
  # "redirect_uri"=>"http://localhost:8080/portal/autenticazione/auth/oauth2/oauth2_callback", 
  # "response_type"=>"code", 
  # "scope"=>"openid", 
  # "controller"=>"doorkeeper/authorizations",
  # "action"=>"new"}
  
  
  resource_owner_authenticator do
    #qui faccio la chiamata al portale (ricavo dal redirect_url l'url da chiamare)
    #se trovo utente ritorno un oggetto user, altrimenti nil
    #user_hash = {:id =>1, :name => 'John', :username => 'Doe'}
    #user = OpenStruct.new(user_hash) 
    #p os.name
    
    if !request.params.blank? && request.params[:client_id].nil?
      request.params ||= {}
      request.params[:redirect_uri] = session[:redirect_uri] #url di callback del portale
      request.params[:client_id] = session[:client_id]
      request.params[:scope] = session[:scope]
      request.params[:response_type] = session[:response_type]
    else
      session[:redirect_uri] = request.params[:redirect_uri] #url di callback del portale
      session[:client_id] = request.params[:client_id]
      session[:scope] = request.params[:scope]
      session[:response_type] = request.params[:response_type]
    end
    
    #session['user'] = {:id =>1, :name => 'John', :username => 'Doe'}
    
    if !session['user'].blank?
      user = OpenStruct.new(session['user'])
      user
    else
      #redirect_to(auth_sign_in_url)
      redirect_to authentication_new_url
      nil
    end
  end



 

  # For Password Grant
  # resource_owner_from_credentials do |routes|
  #   user = User.find_by_email(params[:username].downcase)
  #   if user && user.valid_password?(params[:password])
  #     user
  #   end
  # end

  # If you didn't skip applications controller from Doorkeeper routes in your application routes.rb
  # file then you need to declare this block in order to restrict access to the web interface for
  # adding oauth authorized applications. In other case it will return 403 Forbidden response
  # every time somebody will try to access the admin web interface.
  #
  #Fare login per gestire applicazioni
  admin_authenticator do
    # Put your admin authentication logic here.
    # Example implementation:
    
    # if current_user
    #   head :forbidden unless current_user.admin?
    # else
    #   redirect_to sign_in_url
    # end
  end

  # If you are planning to use Doorkeeper in Rails 5 API-only application, then you might
  # want to use API mode that will skip all the views management and change the way how
  # Doorkeeper responds to a requests.
  #
  # api_only

  # Enforce token request content type to application/x-www-form-urlencoded.
  # It is not enabled by default to not break prior versions of the gem.
  #
  # enforce_content_type

  # Authorization Code expiration time (default 10 minutes).
  #
  # authorization_code_expires_in 10.minutes

  # Access token expiration time (default 2 hours).
  # If you want to disable expiration, set this to nil.
  #
  # access_token_expires_in 2.hours

  # Assign custom TTL for access tokens. Will be used instead of access_token_expires_in
  # option if defined. `context` has the following properties available
  #
  # `client` - the OAuth client application (see Doorkeeper::OAuth::Client)
  # `grant_type` - the grant type of the request (see Doorkeeper::OAuth)
  # `scopes` - the requested scopes (see Doorkeeper::OAuth::Scopes)
  #
  # custom_access_token_expires_in do |context|
  #   context.client.application.additional_settings.implicit_oauth_expiration
  # end

  # Use a custom class for generating the access token.
  # See https://github.com/doorkeeper-gem/doorkeeper#custom-access-token-generator
  #
  
  #access_token_generator '::CustomToken'
  access_token_generator '::Doorkeeper::JWT'

  # The controller Doorkeeper::ApplicationController inherits from.
  # Defaults to ActionController::Base.
  # See https://github.com/doorkeeper-gem/doorkeeper#custom-base-controller
  #
  # base_controller 'ApplicationController'

  # Reuse access token for the same resource owner within an application (disabled by default).
  #
  # This option protects your application from creating new tokens before old valid one becomes
  # expired so your database doesn't bloat. Keep in mind that when this option is `on` Doorkeeper
  # doesn't updates existing token expiration time, it will create a new token instead.
  # Rationale: https://github.com/doorkeeper-gem/doorkeeper/issues/383
  #
  
  reuse_access_token

  # Issue access tokens with refresh token (disabled by default), you may also
  # pass a block which accepts `context` to customize when to give a refresh
  # token or not. Similar to `custom_access_token_expires_in`, `context` has
  # the properties:
  #
  # `client` - the OAuth client application (see Doorkeeper::OAuth::Client)
  # `grant_type` - the grant type of the request (see Doorkeeper::OAuth)
  # `scopes` - the requested scopes (see Doorkeeper::OAuth::Scopes)
  #
  # use_refresh_token

  # Forbids creating/updating applications with arbitrary scopes that are
  # not in configuration, i.e. `default_scopes` or `optional_scopes`.
  # (disabled by default)
  #
  # enforce_configured_scopes

  # Provide support for an owner to be assigned to each registered application (disabled by default)
  # Optional parameter confirmation: true (default false) if you want to enforce ownership of
  # a registered application
  # Note: you must also run the rails g doorkeeper:application_owner generator to provide the necessary support
  #
  # enable_application_owner confirmation: false

  # Define access token scopes for your provider
  # For more information go to
  # https://github.com/doorkeeper-gem/doorkeeper/wiki/Using-Scopes
  #
  default_scopes  :public
  # optional_scopes :write, :update
  
  # default_scopes  :public
  # optional_scopes :openid

  # Change the way client credentials are retrieved from the request object.
  # By default it retrieves first from the `HTTP_AUTHORIZATION` header, then
  # falls back to the `:client_id` and `:client_secret` params from the `params` object.
  # Check out https://github.com/doorkeeper-gem/doorkeeper/wiki/Changing-how-clients-are-authenticated
  # for more information on customization
  #
  client_credentials :from_basic, :from_params
  #client_credentials :from_params

  # Change the way access token is authenticated from the request object.
  # By default it retrieves first from the `HTTP_AUTHORIZATION` header, then
  # falls back to the `:access_token` or `:bearer_token` params from the `params` object.
  # Check out https://github.com/doorkeeper-gem/doorkeeper/wiki/Changing-how-clients-are-authenticated
  # for more information on customization
  #
  #access_token_methods :from_basic_authorization, :from_bearer_authorization, :from_access_token_param, :from_bearer_param
  access_token_methods :from_access_token_param

  # Change the native redirect uri for client apps
  # When clients register with the following redirect uri, they won't be redirected to any server and
  # the authorizationcode will be displayed within the provider
  # The value can be any string. Use nil to disable this feature. When disabled, clients must provide a valid URL
  # (Similar behaviour: https://developers.google.com/accounts/docs/OAuth2InstalledApp#choosingredirecturi)
  #
  #native_redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
  
  #native_redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
  native_redirect_uri nil
  
  # Forces the usage of the HTTPS protocol in non-native redirect uris (enabled
  # by default in non-development environments). OAuth2 delegates security in
  # communication to the HTTPS protocol so it is wise to keep this enabled.
  #
  # Callable objects such as proc, lambda, block or any object that responds to
  # #call can be used in order to allow conditional checks (to allow non-SSL
  # redirects to localhost for example).
  #
  # force_ssl_in_redirect_uri !Rails.env.development?
  #
  # force_ssl_in_redirect_uri { |uri| uri.host != 'localhost' }

  # Specify what redirect URI's you want to block during Application creation.
  # Any redirect URI is whitelisted by default.
  #
  # You can use this option in order to forbid URI's with 'javascript' scheme
  # for example.
  #
  # forbid_redirect_uri { |uri| uri.scheme.to_s.downcase == 'javascript' }

  # Specify how authorization errors should be handled.
  # By default, doorkeeper renders json errors when access token
  # is invalid, expired, revoked or has invalid scopes.
  #
  # If you want to render error response yourself (i.e. rescue exceptions),
  # set  handle_auth_errors to `:raise` and rescue Doorkeeper::Errors::InvalidToken
  # or following specific errors:
  #
  #   Doorkeeper::Errors::TokenForbidden, Doorkeeper::Errors::TokenExpired,
  #   Doorkeeper::Errors::TokenRevoked, Doorkeeper::Errors::TokenUnknown
  #
  # handle_auth_errors :raise

  # Specify what grant flows are enabled in array of Strings. The valid
  # strings and the flows they enable are:
  #
  # "authorization_code" => Authorization Code Grant Flow
  # "implicit"           => Implicit Grant Flow
  # "password"           => Resource Owner Password Credentials Grant Flow
  # "client_credentials" => Client Credentials Grant Flow
  #
  # If not specified, Doorkeeper enables authorization_code and
  # client_credentials.
  #
  # implicit and password grant flows have risks that you should understand
  # before enabling:
  #   http://tools.ietf.org/html/rfc6819#section-4.4.2
  #   http://tools.ietf.org/html/rfc6819#section-4.4.3
  #
  # grant_flows %w[authorization_code client_credentials]

  #impostazione per OpenID connect
  #grant_flows %w(authorization_code client_credentials implicit_oidc)

  #grant_flows %w(authorization_code client_credentials)
  grant_flows %w(authorization_code)

  # Hook into the strategies' request & response life-cycle in case your
  # application needs advanced customization or logging:
  #
  # before_successful_strategy_response do |request|
  #   puts "BEFORE HOOK FIRED! #{request}"
  # end
  #
  # after_successful_strategy_response do |request, response|
  #   puts "AFTER HOOK FIRED! #{request}, #{response}"
  # end

  # Hook into Authorization flow in order to implement Single Sign Out
  # or add ny other functionality.
  #
  # before_successful_authorization do |controller|
  #   Rails.logger.info(params.inspect)
  # end
  #
  #Dopo aver creato l'access token arrivo qui e aggiorno il record
  after_successful_authorization do |controller|
    if controller.request.params['response_type'] == 'code'
      hash_user = controller.request.session['user']
      #carico l'ultimo record della oauth_access_grant che contiene l'access token e salvo i dati dell'utente
      oat_user = Doorkeeper::AccessGrant.where(resource_owner_id: hash_user['id'], application_id: hash_user['application_id']).last
      unless oat_user.blank?
        oat_user.user_data = hash_user.to_json
        oat_user.save
        #cancello i vecchi access_grant
        oat_old = Doorkeeper::AccessGrant.where.not(id: oat_user.id ).where(resource_owner_id: hash_user['id'], application_id: hash_user['application_id'])
        oat_old.destroy_all
      end
      #cancello la sessione
      controller.request.session.delete(:client_id)
      controller.request.session.delete('user')
    end
    
  end

  # Under some circumstances you might want to have applications auto-approved,
  # so that the user skips the authorization step.
  # For example if dealing with a trusted application.
  #
  # skip_authorization do |resource_owner, client|
  #   client.superapp? or resource_owner.admin?
  # end
  
  # 3 Qui arriva
  # resource_owner
  #<OpenStruct id=1, name="John", username="Doe">
  # client
 #<Doorkeeper::OAuth::Client:0x00007f322e6d4d38 @application=#<Doorkeeper::Application id: 1, name: "test", 
 #uid: "87256f9997efa4921aadd4caa1940134210d31b59f5685a2f3...", secret: "63e650f8a0d7509f76f53b8d313cdfb80285e74141efa52421...", 
 #redirect_uri: "urn:ietf:wg:oauth:2.0:oob\r\nhttp://localhost:8080/p...", scopes: "", confidential: true, 
 #created_at: "2019-01-30 16:40:28", updated_at: "2019-02-04 10:39:13", image_url: nil, tipo_login: nil>>
 
  skip_authorization do |resource_owner, client|
    true
  end

  # resource_owner_from_credentials do |routes|
  
   
  # end


  # WWW-Authenticate Realm (default "Doorkeeper").
  #
  # realm "Doorkeeper"
end

  


#passa per creare jwt
Doorkeeper::JWT.configure do
  # Set the payload for the JWT token. This should contain unique information
  # about the user. Defaults to a randomly generated token in a hash:
  #     { token: "RANDOM-TOKEN" }
  token_payload do |opts|
    #cerco access token ultimo per questo resource owner e application
    #user = User.find(opts[:resource_owner_id])
    oat_user = Doorkeeper::AccessGrant.where(resource_owner_id: opts[:resource_owner_id], application_id: opts[:application]).last
    {
      iss: 'OES',
      iat: Time.current.utc.to_i,

      # @see JWT reserved claims - https://tools.ietf.org/html/draft-jones-json-web-token-07#page-7
      jti: SecureRandom.uuid,

      user: JSON.parse(oat_user.user_data)
      
    }
  end

  # # Optionally set additional headers for the JWT. See
  # # https://tools.ietf.org/html/rfc7515#section-4.1
  token_headers do |opts|
    { 
      'typ': "JWT",
      'alg': "HS256",
      'kid': opts[:application][:uid],
    }
  end

  # # Use the application secret specified in the access grant token. Defaults to
  # # `false`. If you specify `use_application_secret true`, both `secret_key` and
  # # `secret_key_path` will be ignored.
  # use_application_secret false
  use_application_secret true


  # # Set the encryption secret. This would be shared with any other applications
  # # that should be able to read the payload of the token. Defaults to "secret".
  # secret_key ENV['JWT_SECRET']

  # # If you want to use RS* encoding specify the path to the RSA key to use for
  # # signing. If you specify a `secret_key_path` it will be used instead of
  # # `secret_key`.
  # secret_key_path File.join('path', 'to', 'file.pem')

  # # Specify encryption type (https://github.com/progrium/ruby-jwt). Defaults to
  # # `nil`.
  encryption_method :hs256

end



