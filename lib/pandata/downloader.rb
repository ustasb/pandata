require 'json'
require 'open-uri'

module Pandata
  class Downloader
    CONFIG_URL = 'https://gist.github.com/ustasb/596f1ee96d03463fde77/raw/pandata_config.json'

    class << self
      attr_accessor :cookie
    end

    def initialize
      # If we already have a cookie, don't get another. Finish it first.
      unless Downloader.cookie
        Downloader.cookie = get_cookie
      end
    end

    def read_page(url)
      escaped_url = URI.escape(url)
      open(escaped_url, 'Cookie' => Downloader.cookie).read
    end

    private

    def get_cookie
      config = JSON.parse open(CONFIG_URL).read
      config['cookie']
    end
  end
end
