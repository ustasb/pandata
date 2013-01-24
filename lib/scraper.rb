require_relative 'downloader'
require_relative 'parser'
require_relative 'urls'

module Pandora
  class Scraper
    class << self
      private :new

      def get user_identifier
        search_url = URLS[:search] % { searchString: user_identifier }
        html = Downloader.get(search_url)
        webnames = Parser.new.get_webnames_from_search(html)

        if webnames.length == 1
          new(webnames.first)
        else
          false
        end
      end
    end

    def initialize webname
      @downloader = Downloader.new
      @parser = Parser.new
      @webname = webname
    end

    def stations
      scrape_for :stations, :get_stations
    end

    def bookmarks(bookmark_type = :all)
      case bookmark_type
      when :tracks
        scrape_for :bookmarked_tracks, :get_bookmarked_tracks
      when :artists
        scrape_for :bookmarked_artists, :get_bookmarked_artists
      when :all
        { tracks: bookmarks(:tracks),
          artists: bookmarks(:artists) }
      end
    end

    def likes(like_type = :all)
      case like_type
      when :tracks
        scrape_for :liked_tracks, :get_liked_tracks
      when :artists
        scrape_for :liked_artists, :get_liked_artists
      when :stations
        scrape_for :liked_stations, :get_liked_stations
      when :albums
        scrape_for :liked_albums, :get_liked_albums
      when :all
        { tracks: likes(:tracks),
          artists: likes(:artists),
          stations: likes(:stations),
          albums: likes(:albums) }
      end
    end

    # Can only retrieve profiles that are publicly visible.
    def following
      scrape_for :following, :get_following
    end

    def followers
      scrape_for :followers, :get_followers
    end

    private

    def scrape_for data_type, parser_method
      results = []

      url = get_url data_type
      download_all_data(url) do |html, next_data_indices|
        new_data = @parser.public_send(parser_method, html)
        results.concat(new_data)
        get_url(data_type, next_data_indices) if next_data_indices
      end

      results
    end

    def download_all_data(url, &block)
      next_data_indices = {}

      while next_data_indices
        html = @downloader.read_page(url)
        next_data_indices = @parser.more_data_on_server?(html)
        url = block.call(html, next_data_indices)
      end
    end

    def get_url(data_name, next_data_indices = {})
      if next_data_indices.empty?
        next_data_indices = { nextStartIndex: 0, nextLikeStartIndex: 0, nextThumbStartIndex: 0 }
      end

      next_data_indices[:webname] = @webname
      URLS[data_name] % next_data_indices
    end
  end
end

scraper = Pandora::Scraper.get('Tom Conrad')
if scraper
  p scraper.likes
else
  puts 'ID not found!!!!'
end
