#!/usr/bin/env ruby
require 'httparty'
require 'json'
require 'plural'

# Gives you passwords you can remember
class Nemonic
  PASSWORD_FORMAT = 'number_adjective_animal_verb_noun_symbol'.freeze

  RANDOM_LISTS = %w[adjective animal noun verb].freeze

  RANDOM_LIST_URL = 'https://www.randomlists.com/data/%s.json'.freeze

  def self.password
    password_components = {}

    PASSWORD_FORMAT.split('_').each do |component|
      password_components[component] = random component
    end

    password_components.values.map(&:capitalize).join
  end

  private_class_method def self.random thing
    if respond_to? "random_#{thing}", true
      send("random_#{thing}")
    elsif RANDOM_LISTS.include? thing
      random_from_list thing
    else
      raise "wut #{thing}"
    end
  end

  private_class_method def self.random_from_list thing
    url = RANDOM_LIST_URL % "#{thing}s"
    response = HTTParty.get(url)
    json = JSON.parse(response.body)
    result = json['data'] || json['RandL']['items']
    selection = result.sample
    selection = result.sample while selection.split.length > 1
    selection
  end

  private_class_method def self.random_number
    # At more than 1 digit, the number becomes easy to forget, IMO
    rand(2..9).to_s
  end

  private_class_method def self.random_animal
    # Multiple animals are always funnier than single animals
    animal = random_from_list 'animal'
    animal.plural
  end

  private_class_method def self.random_symbol
    # So random
    '!'
  end
end

puts Nemonic.password
