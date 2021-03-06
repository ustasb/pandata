require_relative 'spec_helper'
require 'pandata/argv_parser'

describe Pandata::ArgvParser do
  it 'does not allow instances of itself' do
    expect { described_class.new }.to raise_error NoMethodError
  end

  describe '.parse' do
    it 'returns an options hash with no duplicates' do
      argv = [
        'yoda',
        '--json',
        '--all',
        '-l',
        '-L',
        '-o',
        'my_data.json',
        '-m',
        '-n',
        '-F',
        '-f',
        # Duplicates
        '-lLmnfF',
        '-l',
        '--json',
        '--all'
      ]

      options = described_class.parse(argv)

      expect(options[:user_id]).to eq 'yoda'
      expect(options[:output_file]).to eq 'my_data.json'
      expect(options[:return_as_json]).to eq true
      expect(options[:data_to_get]).to eq [
        :liked_tracks,
        :liked_artists,
        :liked_albums,
        :liked_stations,
        :followers,
        :following
      ]
    end
  end
end
