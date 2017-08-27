require 'httparty'
require 'json'

PASSWORD_FORMAT="adjective_animal_verb_noun".freeze

def get_random thing
	url="https://www.randomlists.com/data/#{thing}s.json"
	response = HTTParty.get(url)
	json=JSON.parse(response.body)
	result = json['data'] || json['RandL']['items']
	selection = result.sample
	while selection.split.length > 1
		selection = result.sample
	end
	return selection
end

def generate_password
	password_components = {}

	PASSWORD_FORMAT.split('_').each do |component|
		password_components[component] = get_random component
	end

	password_components['verb'] += 's'

	return password_components.values.join(' ')
end

puts generate_password