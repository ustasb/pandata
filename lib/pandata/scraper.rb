require_relative 'data_urls'
require_relative 'parser'
require_relative 'downloader'

module Pandata

  # Downloads a user's Pandora data.
  # A user's profile must be public for Pandata to download its data.
  class Scraper

    # What Pandora uses to identify a user and it remains constant even if
    # the user ties a new email address to their Pandora account.
    attr_reader :webname

    # Takes either an email or webname string.
    # Returns either:
    # - a new scraper object for the supplied user ID.
    # - an array of similar webnames because a matching Pandora user could not be found.
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

    # Returns an array of the user's recent activity.
    def recent_activity
      scrape_for(:recent_activity, :get_recent_activity)
    end

    # Returns the user's currently playing station.
    def playing_station
      scrape_for(:playing_station, :get_playing_station).first
    end

    # Returns an array of the user's stations.
    def stations
      scrape_for(:stations, :get_stations)
    end

    # Returns a user's bookmarked data.
    #
    # Bookmark types:
    # - :artists - Returns an array of artist names.
    # - :tracks - Returns an array of hashes with :artist and :track keys.
    # - :all - Returns a hash with all bookmarked data.
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

    # Returns a user's liked data. (The results from giving a 'thumbs up.')
    #
    # Like types:
    # - :artists - Returns an array of artist names.
    # - :albums - Returns an array of album names.
    # - :stations - Returns an array of station names.
    # - :tracks - Returns an array of hashes with :artist and :track keys.
    # - :all - Returns a hash with all liked data.
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

    # Returns the *public* users being followed by the user.
    #
    # Returns an array of hashes with keys:
    # - :name - Profile name
    # - :webname - Unique Pandora ID
    # - :href - URL to online Pandora profile.
    def following
      scrape_for(:following, :get_following)
    end

    # Returns the user's followers in a format identical to #following.
    def followers
      scrape_for(:followers, :get_followers)
    end

    private

    # Downloads all data for a given type, calls the supplied Pandata::Parser
    # method and removes any duplicates.
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
    def download_all_data(url)
      next_data_indices = {}

      while next_data_indices
        html = @downloader.read_page(url)
        next_data_indices = @parser.get_next_data_indices(html)
        url = yield(html, next_data_indices)
      end
    end

    # Grabs a URL from DATA_FEED_URLS and formats it appropriately.
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
