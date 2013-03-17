require_relative 'data_urls'
require_relative 'parser'
require_relative 'downloader'

module Pandata

  # Downloads a user's Pandora.com data.
  # A user's profile must be public for Pandata to download its data.
  class Scraper

    # What Pandora uses to identify a user and it remains constant even if
    # the user ties a new email address to their Pandora account.
    attr_reader :webname

    # If possible, get a Scraper instance for the user_id otherwise return
    # an array of similar webnames.
    # @param user_id [String] email or webname
    # @return [Scraper] a scraper object for the supplied user ID
    # @return [Array] array of similar webnames because a matching Pandora user could not be found
    def self.get(user_id)
      search_url = DATA_FEED_URLS[:user_search] % { searchString: user_id }
      html = Downloader.new.read_page(search_url)
      webnames = Parser.new.get_webnames_from_search(html)

      if webnames.include?(user_id)
        new(user_id)
      # If user_id looks like an email and still gets a result.
      elsif webnames.size == 1 && /.*@.*\..*/ =~ user_id
        new(webnames.first)
      else
        webnames
      end
    end

    private_class_method :new
    def initialize(webname)
      @downloader = Downloader.new
      @parser = Parser.new
      @webname = webname
    end

    # Get the user's recent activity.
    # @return [Array] array of activity names
    def recent_activity
      scrape_for(:recent_activity, :get_recent_activity)
    end

    # Get the user's playing station.
    # @return [String]
    def playing_station
      scrape_for(:playing_station, :get_playing_station).first
    end

    # Get the user's stations.
    # @return [Array] array of station names
    def stations
      scrape_for(:stations, :get_stations)
    end

    # Get the user's bookmarked data.
    # @param bookmark_type [Symbol]
    #   - :artists - returns an array of artist names
    #   - :tracks - returns an array of hashes with :artist and :track keys
    #   - :all - returns a hash with all bookmarked data
    def bookmarks(bookmark_type = :all)
      case bookmark_type
      when :tracks
        scrape_for(:bookmarked_tracks, :get_bookmarked_tracks)
      when :artists
        scrape_for(:bookmarked_artists, :get_bookmarked_artists)
      when :all
        { artists: bookmarks(:artists),
          tracks: bookmarks(:tracks) }
      end
    end

    # Get the user's liked data. (The results from giving a 'thumbs up.')
    # @param like_type [Symbol]
    #   - :artists - returns an array of artist names
    #   - :albums - returns an array of album names
    #   - :stations - returns an array of station names
    #   - :tracks - returns an array of hashes with :artist and :track keys
    #   - :all - returns a hash with all liked data
    def likes(like_type = :all)
      case like_type
      when :tracks
        scrape_for(:liked_tracks, :get_liked_tracks)
      when :artists
        scrape_for(:liked_artists, :get_liked_artists)
      when :stations
        scrape_for(:liked_stations, :get_liked_stations)
      when :albums
        scrape_for(:liked_albums, :get_liked_albums)
      when :all
        { artists: likes(:artists),
          albums: likes(:albums),
          stations: likes(:stations),
          tracks: likes(:tracks) }
      end
    end

    # Get the *public* users being followed by the user.
    # @return [Array] array of hashes with keys:
    #   - :name - profile name
    #   - :webname - unique Pandora ID
    #   - :href - URL to online Pandora profile
    def following
      scrape_for(:following, :get_following)
    end

    # Get the user's *public* followers.
    # @return [Array] identical to #following
    def followers
      scrape_for(:followers, :get_followers)
    end

    private

    # Downloads all data for a given type, calls the supplied Pandata::Parser
    # method and removes any duplicates.
    # @param data_type [Symbol]
    # @param parser_method [Symbol] method to be sent to the Parser instance
    # @return [Array]
    def scrape_for(data_type, parser_method)
      results = []

      url = get_url(data_type)
      download_all_data(url) do |html, next_data_indices|
        new_data = @parser.public_send(parser_method, html)

        if new_data.kind_of?(Array)
          results.concat(new_data)
        else
          results.push(new_data)
        end

        get_url(data_type, next_data_indices) if next_data_indices
      end

      # Pandora data often contains duplicates--get rid of them.
      results.uniq
    end

    # Downloads all data given a starting URL. Some Pandora feeds only return
    # 5 - 10 items per page but contain a link to the next set of data. Threads
    # cannot be used because page A be must visited to know how to obtain page B.
    # @param url [String]
    def download_all_data(url)
      next_data_indices = {}

      while next_data_indices
        html = @downloader.read_page(url)
        next_data_indices = @parser.get_next_data_indices(html)
        url = yield(html, next_data_indices)
      end
    end

    # Grabs a URL from DATA_FEED_URLS and formats it appropriately.
    # @param data_name [Symbol]
    # @param next_data_indices [Symbol] query parameters to get the next set of data
    def get_url(data_name, next_data_indices = {})
      next_data_indices = {
        nextStartIndex: 0,
        nextLikeStartIndex: 0,
        nextThumbStartIndex: 0
      } if next_data_indices.empty?

      next_data_indices[:webname] = @webname
      DATA_FEED_URLS[data_name] % next_data_indices
    end

  end
end
