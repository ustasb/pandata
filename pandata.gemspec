require './lib/pandata.rb'

Gem::Specification.new do |s|
  s.name                          = 'pandata'
  s.version                       = Pandata::Version::STRING
  s.date                          = '2013-02-25'
  s.summary                       = 'A Pandora web scraper'
  s.description                   = 'A library and tool for downloading Pandora data (likes, bookmarks, stations, etc.)'
  s.homepage                      = 'https://github.com/ustasb/pandata'
  s.license                       = 'MIT'
  s.authors                       = ['Brian Ustas']
  s.email                         = 'brianustas@gmail.com'
  s.files                         = Dir.glob('lib/**/*.rb') << 'bin/pandata'
  s.executables                   << 'pandata'
  s.add_runtime_dependency        'nokogiri', '>= 1.5.6'
  s.add_development_dependency    'rspec', '>= 2.12.2'
end
