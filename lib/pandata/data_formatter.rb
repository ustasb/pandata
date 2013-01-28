require 'set'

module Pandata
  class DataFormatter
    def list values
      values = [values] unless values.kind_of? Array
      str = ''
      values.each { |item| str << "  - #{item}\n" }
      str
    end

    def uniq_sort_list values
      list values.uniq.sort
    end

    def tracks tracks
      artists_items tracks, :track
    end

    def albums albums
      artists_items albums, :album
    end

    def followx value
      str = ''
      value.each do |hash|
        str << "  - name: #{hash[:name]}\n"
        str << "    webname: #{hash[:webname]}\n"
        str << "    href: #{hash[:href]}\n"
      end
      str
    end

    private

    def artists_items value, item_name
      artist_items = {}

      value.each do |hash|
        artist_name = hash[:artist]
        (artist_items[artist_name] ||= Set.new) << hash[item_name]
      end

      str = ''
      artist_items.sort.each do |artist_name, items|
        str << "  - #{artist_name}\n"
        items.sort.each do |item|
          str << "      - #{item}\n"
        end
      end

      str
    end
  end
end
