require 'net/http'
require 'uri'

module Pandora
  class Downloader
    COOKIES = ['at=wSS/+MM34vcWDcbXBjCHIEqaNLEkpjQwtMnlj1+17gagXRISD1d86ADo+5UQmTpLjN1p126cjZfw%3D']

    def self.get url
      new.read_page url
    end

    def read_page url
      uri = URI.parse URI.escape(url)

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      request['Cookie'] = get_random_cookie

      http.request(request).body
    end

    private

    def get_random_cookie
      Downloader::COOKIES.shuffle.first
    end
  end
end
