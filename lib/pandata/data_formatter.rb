require 'set'

module Pandata

  # Sorts and formats Pandata::Scraper data as a string for printing.
  class DataFormatter

    # Returns a string with each array item on its own line.
    # @param data [Array, String]
    # @return [String]
    def list(data)
      data = [data] unless data.kind_of?(Array)
      str = ''
      data.each { |item| str << "  - #{item}\n" }
      str
    end

    # Identical to #list but sorts alphabetically ignoring 'the'.
    # @param data [Array]
    # @return [String]
    def sort_list(data)
      list custom_sort(data)
    end

    # Returns a string with tracks grouped under owning artist.
    # @param tracks [Array] array of hashes with :artist and :track keys
    # @return [String]
    def tracks(tracks)
      artists_items(tracks, :track)
    end

    # Returns a string with albums grouped under owning artist.
    # @param albums [Array] array of hashes with :artist and :album keys
    # @return [String]
    def albums(albums)
      artists_items(albums, :album)
    end

    # Returns a string with followers sorted by webname.
    # @param data [Array] array of hashes with :name, :webname and :href keys
    # @return [String]
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

    # Sorts alphabetically ignoring the initial 'The' when sorting strings.
    # Also case-insensitive to prevent lowercase names from being sorted last.
    # @param enumerable [Array, Hash]
    # @return [Array, Hash]
    def custom_sort(enumerable)
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

    # Returns a string with items grouped under their owning artist.
    # @param data [Array] array of hashes with :artist and another key belonging to an
    #   artist (e.g. :track or :album)
    # @param item_name [Symbol] item name belonging to artists
    # @return [String] string with each artist name on a line with the artist's items
    #   listed and indented below. Sorts the output, too.
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
