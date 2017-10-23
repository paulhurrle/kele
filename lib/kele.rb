class Kele
	include HTTParty
	bloc_api 'https://www.bloc.io/api/v1'
	user_auth_token self.class.post('https://www.bloc.io/api/v1/sessions', kele_params)

	def self.initialize(bloc_api, user_auth_token)
		@bloc_api = bloc_api
		@user_auth_token = user_auth_token
		@kele = Kele.new(@bloc_api, @user_auth_token)
	end

	private

    def kele_params
        params.require(:kele).permit(:username, :password)
    end

end