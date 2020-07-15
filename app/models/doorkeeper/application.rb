module Doorkeeper
    class Application < ActiveRecord::Base
        
        # def as_json(options={})
        #     return self.attributes.as_json
        # end

        def as_json(options = {})
            super
        end

    end
end