# encoding: utf-8

require_relative 'pandata/data_urls'
require_relative 'pandata/downloader'
require_relative 'pandata/parser'
require_relative 'pandata/scraper'

module Pandata
  class PandataError < StandardError; end

  module Version
    MAJOR = 2
    MINOR = 0
    PATCH = 0
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end

