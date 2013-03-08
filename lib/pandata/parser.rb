require 'nokogiri'

module Pandata

  # Parses HTML/XML pages from Pandora for relevant data.
  class Parser

    # Returns an array of webnames.
    def get_webnames_from_search(html)
      user_links = Nokogiri::HTML(html).css('.user_name a')
      webnames = []

      user_links.each do |link|
        webnames << link['webname']
      end

      webnames
    end

    # Returns the query parameters necessary to get the next page of data
    # from Pandora.
    def get_next_data_indices(html)
      show_more = Nokogiri::HTML(html).css('.show_more')[0]

      if show_more
        next_indices = {}
        data_attributes = ['nextStartIndex', 'nextLikeStartIndex', 'nextThumbStartIndex']
        data_attributes.each do |attr_name|
          attr = show_more.attributes['data-' + attr_name.downcase]
          next_indices[attr_name.to_sym] = attr.value.to_i if attr
        end

        next_indices
      else
        false
      end
    end

    # Returns an array of recent activities.
    def get_recent_activity(xml)
      activity_names = []

      xml_each_item(xml) do |title|
        activity_names << title
      end

      activity_names
    end

    # Returns an array of station names.
    def get_stations(xml)
      stations = []

      xml_each_item(xml) do |title|
        stations << title
      end

      stations
    end

    # Returns the currently playing station name.
    def get_playing_station(xml)
      station = ''

      xml_each_item(xml) do |title|
        station = title  # First title is the station name.
        break
      end

      station
    end

    # Returns an array of hashes with :artist and :track keys.
    def get_bookmarked_tracks(xml)
      tracks = []

      xml_each_item(xml) do |title|
        track, artist = title.split(' by ')
        tracks << { artist: artist, track: track }
      end

      tracks
    end

    # Returns an array of artist names.
    def get_bookmarked_artists(xml)
      artists = []

      xml_each_item(xml) do |title|
        artists << title
      end

      artists
    end

    # Returns an array of hashes with :artist and :track keys.
    def get_liked_tracks(html)
      tracks = []

      infobox_each_link(html) do |title, subtitle|
        tracks << { track: title, artist: subtitle }
      end

      tracks
    end

    # Returns an array of artist names.
    def get_liked_artists(html)
      get_infobox_titles(html)
    end

    # Returns an array of station names.
    def get_liked_stations(html)
      get_infobox_titles(html)
    end

    # Returns an array of hashes with :artist and :album keys.
    def get_liked_albums(html)
      albums = []

      infobox_each_link(html) do |title, subtitle|
        albums << { album: title, artist: subtitle }
      end

      albums
    end

    # Returns an array of hashes with :name, :webname and :href keys.
    def get_following(html)
      get_followx_users(html)
    end

    # Returns an array of hashes with :name, :webname and :href keys.
    def get_followers(html)
      get_followx_users(html)
    end

    private

    # Loop over each 'item' tag and yield the title and description.
    def xml_each_item(xml)
      Nokogiri::XML(xml).css('item').each do |item|
        title = item.at_css('title').text
        desc = item.at_css('description').text
        yield(title, desc)
      end
    end

    # Loop over each .infobox container and yield the title and subtitle.
    def infobox_each_link(html)
      Nokogiri::HTML(html).css('.infobox').each do |infobox|
        infobox_body = infobox.css('.infobox-body')

        title_link = infobox_body.css('h3 a').text.strip
        subtitle_link = infobox_body.css('p a').first
        subtitle_link = subtitle_link.text.strip if subtitle_link

        yield(title_link, subtitle_link)
      end
    end

    # Returns an array of titles from #infobox_each_link.
    def get_infobox_titles(html)
      titles = []
      infobox_each_link(html) { |title| titles << title }
      titles
    end

    # Loops over each .follow_section container and return a hash with
    # :name, :webname and :href keys.
    def get_followx_users(html)
      users = []

      Nokogiri::HTML(html).css('.follow_section').each do |section|
        listener_name = section.css('.listener_name').first
        webname = listener_name['webname']

        # Remove any 'spans with a space' that sometimes appear with special characters.
        listener_name.css('span').each(&:remove)
        name = listener_name.text.strip

        href = section.css('a').first['href']

        users << { name: name, webname: webname, href: href }
      end

      users
    end

  end
end
