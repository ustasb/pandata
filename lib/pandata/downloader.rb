require 'json'
require 'open-uri'
require_relative '../pandata'

module Pandata

  # Retrieves data from Pandora.com and handles network errors.
  class Downloader

    # A GitHub Gist that contains an updated cookie allowing access to 'login-only' visible data.
    CONFIG_URL = 'https://gist.github.com/ustasb/596f1ee96d03463fde77/raw/pandata_config.json'

    # The cached config hash.
    @@config = nil

    # Downloads and reads a page from a URL.
    # @param url [String]
    # @return [String] contents of page
    def self.read_page(url)
      download(url, get_config['cookie']).read
    end

    # Returns a pat token needed for mobile requests.
    # @return [String]
    def self.get_pat
      get_config['pat']
    end

    private

    # Downloads a page and handles errors.
    # @param url [String]
    # @param cookie [String]
    # @return [File]
    def self.download(url, cookie = '')
      escaped_url = URI.escape(url)

      open(escaped_url, 'Cookie' => cookie, :read_timeout => 5)
    rescue OpenURI::HTTPError => error
      puts "The network request for:\n  #{url}\nreturned an error:\n  #{error.message}"
      puts "Please try again later or update Pandata. Sorry about that!\n\nFull error:"
      raise PandataError
    end

    def self.get_config
      @@config ||= download_config
    end

    def self.download_config
      config = JSON.parse download(CONFIG_URL).read

      if Gem::Version.new(Pandata::Version::STRING) <= Gem::Version.new(config['required_update_for'])
        raise PandataError, 'Pandora.com has changed something and you need to update Pandata!'
      end

      config
    end

  end
end
