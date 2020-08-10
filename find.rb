#!/usr/env ruby

# TODO: Replace icon in Workflow
# TODO: Show Emoji as result icon is possible


require 'json'

# TODO: Make Rocket install location configurable
ROCKET_INSTALL_LOCATION = "/Applications/Rocket.app"

# TODO: Check if there's a better file/API to use
ROCKET_FILE_NAME = "Contents/Resources/emoji-en.json"

def find(emoji_name)
  emoji_file = File.read("#{ROCKET_INSTALL_LOCATION}/#{ROCKET_FILE_NAME}")
  emoji_json = JSON.parse(emoji_file, symbolize_names: true)

  # TODO: make it a wildcard regex search
  # TODO: check the keywords array as well
  matching_emojis = emoji_json.select{|emoji| emoji[:short_names].include?(emoji_name)}

  # example: [{:content=>"👋", :language=>"en", :short_names=>["wave"], :name=>"waving hand", :keywords=>["goodbye"]}]
  # TODO: Add keywords and short names as a subtitle
  alfred_items = matching_emojis.map do |matching_emoji|
    {
      title: matching_emoji[:name],
      arg: matching_emoji[:content]
    }

  end

  puts({ items: alfred_items}.to_json)
end

find(ARGV[0])