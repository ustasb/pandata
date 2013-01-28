Gem::Specification.new do |s|
  s.name            = 'pandata'
  s.version         = '1.0.0'
  s.date            = '2013-01-27'
  s.summary         = 'A Pandora web scraper'
  s.description     = 'A tool for downloading Pandora data (likes, bookmarks, stations, etc.)'
  s.homepage        = 'https://github.com/ustasb/pandata'
  s.authors         = ['Brian Ustas']
  s.email           = 'brianustas@gmail.com'
  s.files           = ['bin/pandata', 'lib/pandata.rb', 'lib/pandata/scraper.rb',
                       'lib/pandata/downloader.rb', 'lib/pandata/urls.rb',
                       'lib/pandata/parser.rb', 'lib/pandata/argv_parser.rb']
  s.executables     << 'pandata'
end
