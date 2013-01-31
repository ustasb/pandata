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
      list custom_sort(values.uniq)
    end

    def tracks tracks
      artists_items tracks, :track
    end

    def albums albums
      artists_items albums, :album
    end

    def followx value
      str = ''
      value.uniq.sort_by { |item| item[:webname].downcase }.each do |hash|
        str << "  - name: #{hash[:name]}\n"
        str << "    webname: #{hash[:webname]}\n"
        str << "    href: #{hash[:href]}\n"
      end
      str
    end

    private

    def custom_sort(enum)
      # Ignore the initial 'The' when sorting strings.
      # Useful for sorting artist/ song titles.
      sorted_array = enum.sort_by { |string, _| string.sub(/^the\s*/i, '') }

      if enum.kind_of? Hash
        sorted_hash = {}
        sorted_array.each { |item| sorted_hash[item[0]] = item[1] }
        sorted_hash
      else
        sorted_array
      end
    end

    def artists_items value, item_name
      artist_items = {}

      value.each do |hash|
        artist_name = hash[:artist]
        (artist_items[artist_name] ||= Set.new) << hash[item_name]
      end

      artist_items = custom_sort(artist_items)

      str = ''
      artist_items.each do |artist_name, items|
        str << "  - #{artist_name}\n"
        items.sort.each do |item|
          str << "      - #{item}\n"
        end
      end
      str
    end
  end
end
