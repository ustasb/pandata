require 'nokogiri'

module Pandata

  # Parses HTML/XML pages from Pandora for relevant data.
  class Parser

    # Get the webnames from a user ID search.
    # @param html [String]
    # @return [Array] array of webnames
    def get_webnames_from_search(html)
      user_links = Nokogiri::HTML(html).css('.user_name a')
      webnames = []

      user_links.each do |link|
        webnames << link['webname']
      end

      webnames
    end

    # Get the query parameters necessary to get the next page of data from Pandora.
    # @param html [String]
    # @return [Hash, False]
    def get_next_data_indices(html)
      # .js-more-link is found on mobile pages.
      show_more = Nokogiri::HTML(html).css('.show_more, .js-more-link')[0]

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

    # @param html [String]
    # Returns an array of hashes with :artist and :track keys.
    def get_liked_tracks(html)
      tracks = []

      doublelink_each_link(html) do |title, subtitle|
        artist = subtitle.sub(/^by\s/i, '')
        tracks << { track: title, artist: artist }
      end

      tracks
    end

    # @param html [String]
    # Returns an array of artist names.
    def get_liked_artists(html)
      get_infobox_titles(html)
    end

    # @param html [String]
    # Returns an array of station names.
    def get_liked_stations(html)
      get_infobox_titles(html)
    end

    # @param html [String]
    # Returns an array of hashes with :artist and :album keys.
    def get_liked_albums(html)
      albums = []

      infobox_each_link(html) do |title, subtitle|
        albums << { album: title, artist: subtitle }
      end

      albums
    end

    # @param html [String]
    # Returns an array of hashes with :name, :webname and :href keys.
    def get_following(html)
      get_followx_users(html)
    end

    # @param html [String]
    # Returns an array of hashes with :name, :webname and :href keys.
    def get_followers(html)
      get_followx_users(html)
    end

    private

    # Loops over each .infobox container and yields the title and subtitle.
    # @param html [String]
    def infobox_each_link(html)
      Nokogiri::HTML(html).css('.infobox').each do |infobox|
        infobox_body = infobox.css('.infobox-body')

        title_link = infobox_body.css('h3 a').text.strip
        subtitle_link = infobox_body.css('p a').first
        subtitle_link = subtitle_link.text.strip if subtitle_link

        yield(title_link, subtitle_link)
      end
    end

    # Loops over each .double-link container and yields the title and subtitle.
    # Encountered on mobile pages.
    # @param html [String]
    def doublelink_each_link(html)
      Nokogiri::HTML(html).css('.double-link').each do |doublelink|
        title_link = doublelink.css('h3 strong').text.strip
        subtitle_link = doublelink.css('.media--backstageMusic__text div').text.strip

        yield(title_link, subtitle_link)
      end
    end


    # @param html [String]
    # Returns an array of titles from #infobox_each_link.
    def get_infobox_titles(html)
      titles = []
      infobox_each_link(html) { |title| titles << title }
      titles
    end

    # Loops over each .follow_section container.
    # @param html [String]
    # @return [Hash] with keys :name, :webname and :href
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
