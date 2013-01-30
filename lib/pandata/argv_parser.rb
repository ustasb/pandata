require 'optparse'

module Pandata
  class ArgvParser
    class << self; private :new; end

    def self.parse args
      options = {}
      options[:data_to_get] = []

      OptionParser.new do |opts|
        opts.banner = 'Usage: pandata [options]'

        opts.on('--json', 'Return the results as JSON') do
          options[:return_as_json] = true
        end

        opts.on('-i', '--identifier ID', 'Pandora email or webname') do |id|
          options[:id] = id
        end

        opts.on('-a', '--recent_activity', 'Get recent activity') do
          options[:data_to_get] << :recent_activity
        end

        opts.on('-S', '--playing_station', 'Get currently playing station') do
          options[:data_to_get] << :playing_station
        end

        opts.on('-s', '--stations', 'Get all stations') do
          options[:data_to_get] << :stations
        end

        opts.on('-b', '--bookmarked_tracks', 'Get all bookmarked tracks') do
          options[:data_to_get] << :bookmarked_tracks
        end

        opts.on('-B', '--bookmarked_artists', 'Get all bookmarked artists') do
          options[:data_to_get] << :bookmarked_artists
        end

        opts.on('-l', '--liked_tracks', 'Get all liked tracks') do
          options[:data_to_get] << :liked_tracks
        end

        opts.on('-L', '--liked_artists', 'Get all liked artists') do
          options[:data_to_get] << :liked_artists
        end

        opts.on('-m', '--liked_albums', 'Get all liked albums') do
          options[:data_to_get] << :liked_albums
        end

        opts.on('-n', '--liked_stations', 'Get all liked stations') do
          options[:data_to_get] << :liked_stations
        end

        opts.on('-f', '--followers', 'Get all ID\'s followers') do
          options[:data_to_get] << :followers
        end

        opts.on('-F', '--following', 'Get all users being followed by ID') do
          options[:data_to_get] << :following
        end
      end.parse! args

      options
    end
  end
end
