# encoding: utf-8

require_relative 'pandata/data_urls'
require_relative 'pandata/downloader'
require_relative 'pandata/parser'
require_relative 'pandata/scraper'
require_relative 'pandata/version'

module Pandata
  class PandataError < StandardError; end
end
