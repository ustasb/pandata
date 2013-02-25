require 'set'

module Pandata
  class DataFormatter
    def list(data)
      data = [data] unless data.kind_of?(Array)
      str = ''
      data.each { |item| str << "  - #{item}\n" }
      str
    end

    def sort_list(data)
      list custom_sort(data)
    end

    def tracks(tracks)
      artists_items(tracks, :track)
    end

    def albums(albums)
      artists_items(albums, :album)
    end

    def followx(data)
      str = ''
      data.sort_by { |item| item[:webname].downcase }.each do |hash|
        str << "  - name: #{hash[:name]}\n"
        str << "    webname: #{hash[:webname]}\n"
        str << "    href: #{hash[:href]}\n"
      end
      str
    end

    private

    def custom_sort(enumerable)
      # Ignore the initial 'The' when sorting strings.
      # Useful for sorting artist names or song titles.
      # Also case insensitive to prevent lowercase names from being displayed last.
      sorted_array = enumerable.sort_by { |key, _| key.sub(/^the\s*/i, '').downcase }

      # sort_by() returns an array when called on hashes.
      if enumerable.kind_of?(Hash)
        # Rebuild the hash.
        sorted_hash = {}
        sorted_array.each { |item| sorted_hash[item[0]] = item[1] }
        sorted_hash
      else
        sorted_array
      end
    end

    def artists_items(data, item_name)
      artists_items = {}

      data.each do |hash|
        artist_name = hash[:artist]
        (artists_items[artist_name] ||= Set.new) << hash[item_name]
      end

      artists_items = custom_sort(artists_items)

      str = ''
      artists_items.each do |artist_name, items|
        str << "  - #{artist_name}\n"
        custom_sort(items).each do |item|
          str << "      - #{item}\n"
        end
      end
      str
    end
  end
end
