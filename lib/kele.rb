require 'httparty'
require 'json'
class Kele
	include HTTParty


	def initialize(email, password)
		params = { body: { email: email, password: password } }
		#look up HTTParty documentation for base_uri
		response = HTTParty.post(base_url("sessions"), params)
		@token = response['auth_token']
		@token
	end

	def me
		response = HTTParty.get(base_url("users/me"), headers: {"authorization" => @token})
		JSON.parse(response.body)
	end

	def mentor_availability
		mentor_id = self.me.fetch("current_enrollment").fetch("mentor_id")
		response = HTTParty.get(base_url("mentors/#{mentor_id}/student_availability"), headers: {"authorization" => @token})
		response.to_a
	end

	private

	def base_url(uri)
		"https://www.bloc.io/api/v1/#{uri}"
	end

	# bloc_api 'https://www.bloc.io/api/v1'
	# user_auth_token self.class.post('https://www.bloc.io/api/v1/sessions', kele_params)

	# def self.initialize(bloc_api, user_auth_token)
	# 	@bloc_api = bloc_api
	# 	@user_auth_token = user_auth_token
	# 	@kele = Kele.new(@bloc_api, @user_auth_token)
	# end

	# private

 #    def kele_params
 #        params.require(:kele).permit(:username, :password)
 #    end

end
# client = Kele.new(email, password)