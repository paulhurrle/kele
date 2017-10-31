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

	def get_messages(page = nil) #if no argument is passed, default will be nil, which can be evaluated later in the method
		values = {
			"page": page ||= 1, #sets default value of page argument to 1 if no argument is passed
		}
		response = HTTParty.get(base_url("message_threads?page=#{page}"), values: values, headers: {"authorization" => @token})
		JSON.parse(response.body)
	end

	def create_message
		sender = self.get_me.fetch("email")
		mentor_id = self.get_me.fetch("current_enrollment").fetch("mentor_id")

		values = {
			sender: sender,
			recipient_id: mentor_id,
			subject: "Royale with cheese",
			'stripped-text' => "That\'s what they call a quarter pounder in France.",
		}

		response = HTTParty.post(base_url("messages"), body: values, headers: {"authorization" => @token})
	end

	def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
<<<<<<< HEAD
=======
		#checkpoint_id => 2162
		#assignment_branch => 'checkpoint_submissions'
		#assignment_commit_link => 'https://github.com/paulhurrle/kele/commits/5'
		#comment => 'test comment'
>>>>>>> checkpoint_submissions
		values = {
		    "assignment_branch": assignment_branch,
		    "assignment_commit_link": assignment_commit_link,
		    "checkpoint_id": checkpoint_id,
		    "comment": comment,
		    "enrollment_id": self.get_me.fetch("current_enrollment").fetch("id"),
		}

		response = HTTParty.post(base_url("checkpoint_submissions"), body: values, headers: {"authorization" => @token})
	end

	private

	def base_url(uri)
		"https://www.bloc.io/api/v1/#{uri}"
	end
end