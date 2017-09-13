$:.push File.expand_path("../lib", __FILE__)
require 'pandata/version'

Gem::Specification.new do |s|
  s.name                          = 'pandata'
  s.version                       = Pandata::Version::STRING
  s.required_ruby_version         = '>= 1.9.3'
  s.summary                       = 'A Pandora.com web scraper'
  s.description                   = 'A library and tool for downloading Pandora.com data.'
  s.homepage                      = 'https://github.com/ustasb/pandata'
  s.license                       = 'MIT'
  s.authors                       = ['Brian Ustas']
  s.email                         = 'brianustas@gmail.com'
  s.files                         = Dir.glob('lib/**/*.rb')
  s.extra_rdoc_files              = %w[LICENSE README.md]
  s.executables                   << 'pandata'
  s.add_runtime_dependency        'nokogiri', '~> 1.6.7'
  s.add_runtime_dependency        'ruby-progressbar', '~> 1.5.1'
  s.add_development_dependency    'rspec', '~> 3.4.0'
  s.add_development_dependency    'vcr', '~> 3.0.1'
  s.add_development_dependency    'webmock', '~> 2.3.2'
  s.add_development_dependency    'yard', '~> 0.8.7.6'
end
