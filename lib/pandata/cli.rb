require 'json'
require 'ruby-progressbar'
require_relative '../pandata'
require_relative 'argv_parser'
require_relative 'data_formatter'

module Pandata

  # Pandata command-line interface
  class CLI

    def self.scrape(argv)
      options = Pandata::ArgvParser.parse(argv)

      if argv.empty? || options[:help]
        puts options[:opts].to_s  # Log usage information
      elsif options[:version]
        puts Pandata::Version::STRING
      else
        new(options).download_and_output
      end
    end

    def initialize(options)
      @data_to_get = options[:data_to_get]
      @output_file = options[:output_file]
      @return_as_json = options[:return_as_json]

      @scraper = scraper_for(options[:user_id])
      @scraper.download_cb = method(:update_progress)
    end

    def update_progress(new_data)
      progressbar.progress += new_data.size
    end

    def download_and_output
      output_data format_data(download_data, @return_as_json)
    end

    private

    def progressbar
      @progressbar ||= ProgressBar.create(
        title: 'Data Downloaded',
        format: '%t: %c',
        total: nil
      )
    end

    def formatter
      @formatter ||= DataFormatter.new
    end

    def log(msg)
      puts msg
    end

    # Writes the data to STDOUT or a file.
    # @param formatted_data [String]
    def output_data(formatted_data)
      @progressbar.stop if @progressbar

      if @output_file
        File.write(@output_file, formatted_data)
      else
        log formatted_data
      end
    end

    # Formats data as a string list or JSON.
    # @param data [Hash]
    # @param json [Boolean]
    # @return [String]
    def format_data(data, json = false)
      if json
        JSON.generate(data)
      else
        data.map do |category, cat_data|
          # Capitalize each word in the category symbol.
          # e.g. :liked_tracks becomes 'Liked Tracks'
          title = category.to_s.split('_').map(&:capitalize).join(' ')

          output = if cat_data.empty?
                     "  ** No Data **\n"
                   else
                     case category
                     when /recent_activity/
                       formatter.list(cat_data)
                     when /liked_tracks|bookmarked_tracks/
                       formatter.tracks(cat_data)
                     when /liked_artists|bookmarked_artists|stations|liked_stations/
                       formatter.sort_list(cat_data)
                     when :liked_albums
                       formatter.albums(cat_data)
                     when /following|followers/
                       formatter.followx(cat_data)
                     end
                   end

          "#{title}:\n#{output}"
        end.join
      end
    end

    # Downloads the user's desired data.
    # @return [Hash]
    def download_data
      scraper_data = {}

      @data_to_get.each do |data_category|
        if /(bookmark|like)e?d_(.*)/ =~ data_category
          method = $1 << 's'  # 'likes' or 'bookmarks'
          argument = $2.to_sym  # :tracks, :artists, :stations or :albums
          scraper_data[data_category] = @scraper.public_send(method, argument)
        else
          scraper_data[data_category] = @scraper.public_send(data_category)
        end
      end

      scraper_data
    end

    # Returns a scraper for the user's id.
    # @param user_id [String] webname or email
    # @return [Pandata::Scraper]
    def scraper_for(user_id)
      scraper = Pandata::Scraper.get(user_id)

      if scraper.kind_of?(Array)
        log "No exact match for '#{user_id}'."

        unless scraper.empty?
          log "\nWebname results for '#{user_id}':\n#{formatter.list(scraper)}"
        end

        raise PandataError, "Could not create a scraper for '#{user_id}'."
      end

      scraper
    end

  end
end
