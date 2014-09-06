require 'vcr'
require 'pandata/downloader'

def relative_path(path)
  File.expand_path(path, File.dirname(__FILE__))
end

def read_path(path)
  File.read relative_path(path)
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end

VCR.configure do |c|
  c.cassette_library_dir = relative_path('fixtures/vcr_cassettes')
  c.hook_into :webmock
end

# By default, the Downloader uses random sessions which upsets VCR. For
# testing, the session can be the same.
Pandata::Downloader.set_session({
  'cookie' => 'at=wR3JtOkD5uML+hpRZts7J9nGAfao51kP9+mWXzdt95pb2iuYxCrLqMlU3pJwmIYf5POmKDqWEOoNNtwtzqvlH7A%3D%3D',
  'pat' => 'VIvLc%2Bo1gVTf25ABfdhG4oqnFMgahcq1RaTcxf1CIe5FByfkhvp2HnhA%3D%3D'
})
