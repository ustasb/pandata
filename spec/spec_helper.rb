require 'vcr'

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
