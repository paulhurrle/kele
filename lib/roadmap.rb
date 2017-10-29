module Roadmap

	def get_roadmap
		roadmap_id = self.get_me.fetch("current_enrollment").fetch("roadmap_id")
		response = HTTParty.get(base_url("roadmaps/#{roadmap_id}"), headers: {"authorization" => @token})
		JSON.parse(response.body)
	end

	def get_checkpoints
		checkpoints = []
		r = self.get_roadmap
		sections = r['sections'] #array of sections
		sections.each do |section|
			section['checkpoints'].each do |c|
				checkpoints << "##{c['id']}: #{c['name']}"
			end
		end
		checkpoints
	end

end