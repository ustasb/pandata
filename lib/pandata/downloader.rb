require 'net/http'
require 'uri'

module Pandata
  class Downloader
    COOKIES = ['at=wR3JtOkD5uML+hpRZts7J9nGAfao51kP9+mWXzdt95pb2iuYxCrLqMlU3pJwmIYf5POmKDqWEOoNNtwtzqvlH7A%3D%3D']

    def read_page url
      uri = URI.parse URI.escape(url)

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      request['Cookie'] = Downloader::COOKIES.sample  # Get a random cookie

      http.request(request).body
    end
  end
end
