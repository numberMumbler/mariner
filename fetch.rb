# frozen_string_literal: true

require 'rss'
require 'net/http'
require 'uri'
require 'logger'

CATEGORIES = %w[cs nlin math q-fin stat econ eess].freeze

LOGGER = Logger.new($stdout)
LOGGER.level = Logger::INFO

PaperInfo = Struct.new(:title, :web_url, :guid, :authors, :pdf_url) do
  def to_s
    "#{title}\n#{authors}\n#{guid}\n#{web_url}\n#{pdf_url}"
  end
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
  paper_info = to_paper_info(item)
  return if already_processed?(paper_info.guid)

  LOGGER.info(paper_info.to_s)

  mark_as_processed(paper_info.guid)
end

def to_paper_info(item)
  id = item.guid.content[/\d+\.\d+/]
  creator = item.dc_creator if item.respond_to?(:dc_creator)

  pdf_url = "https://export.arxiv.org/pdf/#{id}"

  PaperInfo.new(item.title, item.link, "arXiv:#{id}", creator, pdf_url)
end

def already_processed?(_unique_id)
  # Logic to check if the unique_id exists in the database or data store
  false
end

def mark_as_processed(unique_id)
  # Logic to record the unique_id in the database or data store as processed
  LOGGER.info("Marking #{unique_id} as processed")
end

def process_feed(url)
  get_items(url).each { |item| process_item(item) }
rescue Net::HTTPError, URI::InvalidURIError, RSS::InvalidRSSError => e
  LOGGER.error("Failed to fetch or parse the RSS feed: #{e.message}")
end

def main
  CATEGORIES.each { |category| process_feed("https://rss.arxiv.org/rss/#{category}?version=2.0") }
end

main
