require_relative '../lib/pandata/argv_parser'

describe Pandata::ArgvParser do
  it 'does not allow instances of itself' do
    expect { Pandata::ArgvParser.new }.to raise_error NoMethodError
  end

  describe '.parse' do
    it 'returns an options hash with no duplicates' do
      mock_argv = [
        '--json',
        '--all',
        '-u', 'yoda',
        '-a',
        '-S',
        '-s',
        '-b',
        '-B',
        '-l',
        '-L',
        '-m',
        '-n',
        '-F',
        '-f',
        # Duplicates
        '-aSsbBlLmnfF',
        '-s',
        '-l',
        '--json',
        '--all'
      ]

      options = Pandata::ArgvParser.parse(mock_argv)

      expect(options[:user_id]).to eq 'yoda'
      expect(options[:return_as_json]).to eq true
      expect(options[:data_to_get]).to eq [
        :recent_activity,
        :playing_station,
        :stations,
        :bookmarked_tracks,
        :bookmarked_artists,
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
