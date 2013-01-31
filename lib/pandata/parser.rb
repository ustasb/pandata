require 'nokogiri'

module Pandata
  class Parser
    def get_webnames_from_search html
      user_links = Nokogiri::HTML(html).css('.user_name a')
      webnames = []

      user_links.each do |link|
        webnames << link['webname']
      end

      webnames
    end

    def get_next_data_indices html
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

    def get_recent_activity xml
      activity_names = []

      xml_item_each(xml) do |title|
        activity_names << title
      end

      activity_names
    end

    def get_stations xml
      stations = []

      xml_item_each(xml) do |title|
        stations << title
      end

      stations
    end

    def get_playing_station xml
      xml_item_each(xml) do |title|
        return title  # Return the name of the first item
      end
    end

    def get_bookmarked_tracks xml
      tracks = []

      xml_item_each(xml) do |title|
        track, artist = title.split(' by ')
        tracks << { artist: artist, track: track }
      end

      tracks
    end

    def get_bookmarked_artists xml
      artists = []

      xml_item_each(xml) do |title|
        artists << title
      end

      artists
    end

    def get_liked_tracks html
      tracks = []

      infobox_each_link(html) do |title, subtitle|
        tracks << { track: title, artist: subtitle }
      end

      tracks
    end

    def get_liked_artists html
      get_infobox_titles html
    end

    def get_liked_stations html
      get_infobox_titles html
    end

    def get_liked_albums html
      albums = []

      infobox_each_link(html) do |title, subtitle|
        albums << { album: title, artist: subtitle }
      end

      albums
    end

    def get_following html
      get_followx_users html
    end

    def get_followers html
      get_followx_users html
    end

    private

    def xml_item_each xml
      Nokogiri::XML(xml).css('item').each do |item|
        title = item.at_css('title').text
        desc = item.at_css('description').text
        yield(title, desc)
      end
    end

    def infobox_each_link html, &block
      Nokogiri::HTML(html).css('.infobox').each do |infobox|
        infobox_body = infobox.css('.infobox-body')

        title_link = infobox_body.css('h3 a').text.strip
        subtitle_link = infobox_body.css('p a').first
        subtitle_link = subtitle_link.text.strip if subtitle_link

        block.call(title_link, subtitle_link)
      end
    end

    def get_infobox_titles html
      titles = []
      infobox_each_link(html) { |title| titles << title }
      titles
    end

    def get_followx_users html
      users = []

      Nokogiri::HTML(html).css('.follow_section').each do |section|
        listener_name = section.css('.listener_name').first
        webname = listener_name['webname']

        # Remove any 'spans with a space' that sometimes appear with special characters
        listener_name.css('span').each(&:remove)
        name = listener_name.text.strip

        href = section.css('a').first['href']

        users << { name: name, webname: webname, href: href }
      end

      users
    end
  end
end
