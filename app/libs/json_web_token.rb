class JsonWebToken

    def self.encode(payload, exp = 24.hours.from_now)
        JWT.encode(payload, Rails.application.credentials.external_auth_api_key,'HS256')
    end
  
    def self.decode(token)
        body = JWT.decode(token, Rails.application.credentials.external_auth_api_key,'HS256')[0] 
        HashWithIndifferentAccess.new body 
    end

    def self.valid_payload(payload)
        if expired(payload) || payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud]
            return false
        else
            return true
        end 
    end

    def self.valid_token(decoded_token)
        #lo iat deve essere non più vecchio di 10 minuti
	#Rails.logger.debug "\n\n *** JWT CORRENTE: #{decoded_token.inspect}"        
        #data_valida = (DateTime.strptime(decoded_token['start'],"%d%m%Y%H%M%S") > (DateTime.now.new_offset(0)-(((1.0/24)/60)*10)) )
        #considero sia date UTC che date con ora corrente
        data_valida = (Time.strptime(decoded_token['start'],"%d%m%Y%H%M%S") > (Time.now - 10*60)) && (Time.strptime(decoded_token['start'],"%d%m%Y%H%M%S") <= (Time.now)) || \
        (Time.strptime(decoded_token['start']+"+0000","%d%m%Y%H%M%S%Z") > (Time.now.utc - 10*60)) && (Time.strptime(decoded_token['start']+"+0000","%d%m%Y%H%M%S%Z") <= (Time.now.utc))

    end

end
