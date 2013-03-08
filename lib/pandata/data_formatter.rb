require 'set'

module Pandata

  # Sorts and formats Pandata::Scraper data as a string for printing.
  class DataFormatter

    # Takes an array or string and returns a string with each item on its own line.
    #--
    #
    # Example output:
    # - item1
    # - item2
    # - item3
    #
    #++
    def list(data)
      data = [data] unless data.kind_of?(Array)
      str = ''
      data.each { |item| str << "  - #{item}\n" }
      str
    end

    # Same as #list but sorts alphabetically ignoring 'the'.
    def sort_list(data)
      list custom_sort(data)
    end

    # Takes an array of hashes with :artist and :track keys.
    def tracks(tracks)
      artists_items(tracks, :track)
    end

    # Takes an array of hashes with :artist and :album keys.
    def albums(albums)
      artists_items(albums, :album)
    end

    # Takes an array of hashes with :name, :webname and :href keys.
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

    # Takes an array or hash.
    # Sorts alphabetically ignoring the initial 'The' when sorting strings.
    # Also case-insensitive to prevent lowercase names from being sorted last.
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

    # Takes an array of hashes with :artist and another key belonging to an
    # artist (e.g. :track or :album).
    # Returns a string with each artist name on a line with the artist's items
    # listed and indented below. Sorts the output, too.
    #--
    #
    # Example output:
    # - Artist1:
    #   - item2
    #   - item3
    # - Artist2:
    #   - item1
    #   - item1
    #
    #++
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
