# frozen_string_literal: true

require 'rss'
require 'net/http'
require 'uri'

Record = Struct.new(:title, :link, :guid, :authors) do
  def to_s
    "#{title}\n#{authors}\n#{guid}\n#{link}"
  end
end

def process_feed(url)
  get_items(url).each { |item| process_item(item) }
rescue Net::HTTPError, URI::InvalidURIError, RSS::InvalidRSSError => e
  puts "Failed to fetch or parse the RSS feed: #{e.message}"
end

def get_items(feed_url)
  uri = URI.parse(feed_url)
  response = Net::HTTP.get_response(uri)
  unless response.is_a?(Net::HTTPSuccess)
    raise Net::HTTPError,
          "Failed to fetch the RSS feed: #{response.code} #{response.message}"
  end

  feed = RSS::Parser.parse(response.body)
  feed.items
end

def process_item(item)
  record = to_record(item)
  return if already_processed?(record.guid)

  puts "#{record}\n\n"

  mark_as_processed(record.guid)
end

def to_record(item)
  guid = (item.guid.content.match(/^(.+?)v\d+$/)&.captures || []).first
  creator = item.dc_creator if item.respond_to?(:dc_creator)

  Record.new(item.title, item.link, guid, creator)
end

def already_processed?(_unique_id)
  # Logic to check if the unique_id exists in the database or data store
  false
end

def mark_as_processed(unique_id)
  # Logic to record the unique_id in the database or data store as processed
  # puts "  ** Marking #{unique_id} as processed"
end

%w[cs nlin math q-fin stat econ eess].each { |category| process_feed("https://rss.arxiv.org/rss/#{category}?version=2.0") }
