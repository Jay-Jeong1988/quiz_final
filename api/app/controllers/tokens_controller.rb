class TokensController < ApplicationController
    def index
        render json: params
    end
    
    def create
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
            render json: {
                jwt: encode_token({
                    id: user.id,
                    first_name: user.first_name,
                    last_name: user.last_name,
                    full_name: user.full_name,
                    email: user.email,
                    address: user.address,
                    longitude: user.longitude,
                    latitude: user.latitude
                })
            }
        else
            not_found
        end
    end
    
    private
    def encode_token(payload = {}, exp = 24.hours.from_now)
        
        JWT.encode(
            payload,
            Rails.application.secrets.secret_key_base
            )
    end

end