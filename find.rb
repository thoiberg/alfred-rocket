#!/usr/env ruby

require 'json'

# TODO: Make Rocket install location configurable
ROCKET_INSTALL_LOCATION = "/Applications/Rocket.app"

# TODO: Check if there's a better file/API to use
ROCKET_FILE_NAME = "Contents/Resources/emoji-en.json"

def find(emoji_name)
  emoji_file = File.read("#{ROCKET_INSTALL_LOCATION}/#{ROCKET_FILE_NAME}")
  emoji_json = JSON.parse(emoji_file, symbolize_names: true)

  matching_emojis = emoji_json.select do |emoji|
    matches = emoji[:short_names].grep(/.*#{emoji_name}.*/)
    matches += (emoji[:keywords].grep(/.*#{emoji_name}.*/))
    matches.length > 0
  end

  # example: [{:content=>"👋", :language=>"en", :short_names=>["wave"], :name=>"waving hand", :keywords=>["goodbye"]}]
  alfred_items = matching_emojis.map do |matching_emoji|
    subtitle = (matching_emoji[:short_names] + matching_emoji[:keywords]).join(', ')
    {
      title: matching_emoji[:name],
      subtitle: subtitle,
      arg: matching_emoji[:content],
    }

  end

  puts({ items: alfred_items}.to_json)
end

find(ARGV[0])