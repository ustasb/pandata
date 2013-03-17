require 'json'
require 'open-uri'

module Pandata
  # Custom Pandata error
  class PandataError < StandardError; end

  # Retrieves data from Pandora and handles errors.
  class Downloader
    # A GitHub Gist that contains an updated cookie allowing access to 'login-only' visible data.
    CONFIG_URL = 'https://gist.github.com/ustasb/596f1ee96d03463fde77/raw/pandata_config.json'

    class << self
      attr_accessor :cookie
    end

    # Gets a Pandora cookie and returns a Downloader instance.
    def initialize
      unless Downloader.cookie
        Downloader.cookie = get_cookie
      end
    end

    # Downloads and reads a page from a URL.
    # @param url [String]
    # @return [String] contents of page
    def read_page(url)
      download(url, Downloader.cookie).read
    end

    private

    # Downloads a page and handles errors.
    # @param url [String]
    # @param cookie [String]
    # @return [File]
    def download(url, cookie = '')
      escaped_url = URI.escape(url)

      begin
        open(escaped_url, 'Cookie' => cookie, :read_timeout => 5)
      rescue OpenURI::HTTPError => error
        puts "The network request for:\n  #{url}\nreturned an error:\n  #{error.message}"
        puts "Please try again later or update Pandata. Sorry about that!\n\nFull error:"
        raise PandataError
      end
    end

    def get_cookie
      config = JSON.parse download(CONFIG_URL).read

      if Gem::Version.new(Pandata::Version::STRING) <= Gem::Version.new(config['required_update_for'])
        raise PandataError, 'Pandora.com has changed something and you need to update Pandata!'
      end

      config['cookie']
    end
  end
end
