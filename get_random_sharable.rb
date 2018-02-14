#
# Some passwords need to be shared with others, and
# I can't always expect those others to use LastPass.
#
# So we're going to use:
# "{number} {adjective} {animals} {verb} {noun} {symbol}"
# This ought to make it memorable, and reasonably random.
#
# Warning: This is a joke script, and really shouldn't be
# used to create a password for anything more important
# than your Netflix subscription.
#

require 'httparty'
require 'json'
# Ruby doesn't know how to pluralize. Rails does.
require 'active_support/inflector'

PASSWORD_FORMAT="number_adjective_animal_verb_noun_symbol".freeze

RANDOM_LISTS = [
  'adjective',
  'animal',
  'noun',
  'verb'
]

def get_random thing
  if respond_to? "get_random_#{thing}", true
    send("get_random_#{thing}")
  elsif RANDOM_LISTS.include? thing
    get_random_from_list thing
  else
    raise "wut #{thing}"
  end
end

def get_random_from_list thing
  url="https://www.randomlists.com/data/#{thing}s.json"
  response = HTTParty.get(url)
  json=JSON.parse(response.body)
  result = json['data'] || json['RandL']['items']
  selection = result.sample
  while selection.split.length > 1
    selection = result.sample
  end
  selection
end

def get_random_number
  # At more than 1 digit, the number becomes easy to forget, IMO
  return (2+rand(8)).to_s
end

def get_random_animal
  # Multiple animals are always funnier than single animals
  animal = get_random_from_list 'animal'
  return animal.pluralize
end

def get_random_symbol
  # So random
  return '!'
end

def generate_password
	password_components = {}

	PASSWORD_FORMAT.split('_').each do |component|
		password_components[component] = get_random component
	end

  password_components.values.map(&:capitalize).join()
end

puts generate_password
