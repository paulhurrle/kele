require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
	include HTTParty
	include Roadmap

	def initialize(email, password)
		params = { body: { email: email, password: password } }
		#look up HTTParty documentation for base_uri
		response = HTTParty.post(base_url("sessions"), params)
		@token = response['auth_token']
		@token
	end

	def get_me
		response = HTTParty.get(base_url("users/me"), headers: {"authorization" => @token})
		JSON.parse(response.body)
	end

	def get_mentor_availability
		mentor_id = self.get_me.fetch("current_enrollment").fetch("mentor_id")
		response = HTTParty.get(base_url("mentors/#{mentor_id}/student_availability"), headers: {"authorization" => @token})
		response.to_a
	end

	private

	def base_url(uri)
		"https://www.bloc.io/api/v1/#{uri}"
	end
end