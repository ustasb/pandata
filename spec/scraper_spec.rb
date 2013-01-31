require_relative 'test_helpers'
require_relative '../lib/pandata/scraper'

describe Pandata::Scraper do
  describe 'Scraper.get' do

    # Stub Downloader's `read_page` instance method
    def override_network_return path
      Pandata::Downloader.class_eval do
        define_method(:read_page) { |url| File.read(path) }
      end
    end

    it 'returns a new Scraper instance if a webname exactly matches the user\'s search' do
      override_network_return File.join('spec', 'fixtures', 'ajax', 'no_more', 'search_results_for_lols.html')
      result = Pandata::Scraper.get 'lols'
      expect(result.class).to eq Pandata::Scraper
      expect(result.webname).to eq 'lols'
    end

    it 'returns an array of similar webnames if no matching webname is found' do
      override_network_return File.join('spec', 'fixtures', 'ajax', 'show_more', 'search_results_for_skittle.html')
      result = Pandata::Scraper.get 'skittle'
      expect(result).to eq [
        'sixx_miley',
        'sydni00girly',
        'skittle_lovee',
        'puff_skittle',
        'shawniagreene',
        'emma13820',
        'davonnacarney',
        'brittle-skittle',
        'skittle-bunnie',
        'mr_skittle',
        'kylie246',
        'sweetsophie10',
        'drewwhorton',
        'skittle_sz_21',
        'rawr_skittle_lover']
    end
  end

  describe 'a Scraper instance' do
    def stub_get_url(*args)
      @scraper.stub(:get_url).and_return(File.join(*args))
    end

    before(:each) do
      # Skip Scraper.get
      @scraper = Pandata::Scraper.send(:new, 'pandorastats')

      Pandata::Downloader.class_eval do
        # Read a file instead of make a network request
        define_method(:read_page) { |path| File.read(path) }
      end
    end

    describe '#recent_activity' do
      before(:each) do
        stub_get_url('spec', 'fixtures', 'feeds', 'recent_activity.xml')
      end

      it 'returns an array of activity names' do
        activity = @scraper.recent_activity
        expect(activity).to eq [
          'Drake',
          'George Strait',
          'Future',
          'Ssion',
          'Gucci Mane',
          'Frank Ocean',
          'Rage Against The Machine',
          'Lady Gaga',
          'Loverboy',
          'Lil Wayne',
          'HYFR (Hell Ya Fucking Right) by Drake',
          'Human by The Killers',
          'Drake Radio']
      end
    end

    describe '#playing_station' do
      before(:each) do
        stub_get_url('spec', 'fixtures', 'feeds', 'station_now_playing.xml')
      end

      it 'returns the name of the current station playing' do
        station = @scraper.playing_station
        expect(station).to eq 'Drake Radio'
      end
    end

    describe '#stations' do
      before(:each) do
        stub_get_url('spec', 'fixtures', 'feeds', 'stations.xml')
      end

      it 'returns an array of station names' do
        stations = @scraper.stations
        expect(stations).to eq [
          'Drake Radio',
          'George Strait Radio',
          'Future Radio',
          'Ssion Radio',
          'Gucci Mane Radio',
          'Frank Ocean Radio',
          'Loverboy Radio',
          'Lil Wayne Radio',
          'Fun. Radio',
          'The Killers Radio',
          'pandorastats\'s QuickMix']
      end
    end

    describe '#bookmarks' do
      context 'passed the :tracks argument' do
        before(:each) do
          stub_get_url('spec', 'fixtures', 'feeds', 'bookmarked_tracks.xml')
        end

        it 'returns an array of hashes with track name and artist names' do
          tracks = @scraper.bookmarks :tracks
          expect(tracks).to eq [
            { artist: 'A Boy and His Kite',                 track: 'Cover Your Tracks' },
            { artist: 'Royksopp',                           track: 'Royksopp Forever' },
            { artist: 'The National',                       track: 'Lucky You' },
            { artist: 'Radical Face',                       track: 'Welcome Home' },
            { artist: 'Margot & The Nuclear So And So\'s',  track: 'Broadripple Is Burning (Daytrotter Sessions)' }]
        end
      end

      context 'passed the :artists argument' do
        before(:each) do
          stub_get_url('spec', 'fixtures', 'feeds', 'bookmarked_artists.xml')
        end

        it 'returns an array of artist names' do
          artists = @scraper.bookmarks :artists
          expect(artists).to eq [
            'Trampled By Turtles',
            'Adele',
            'DJ Logic',
            'Whitley',
            'Mumford & Sons']
        end
      end
    end

    describe '#likes' do
      context 'passed the :tracks argument' do
        before(:each) do
          stub_get_url('spec', 'fixtures', 'ajax', 'no_more', 'liked_tracks.html')
        end

        it 'returns an array of hashes with track and artist names' do
          tracks = @scraper.likes :tracks
          expect(tracks).to eq [
            { artist: 'Of Monsters & Men',  track: 'Lakehouse' },
            { artist: 'Phoenix',            track: 'Lasso' },
            { artist: 'Sean Watkins',       track: 'Hello...Goodbye' },
            { artist: 'Paloma Faith',       track: 'My Legs Are Weak' },
            { artist: 'Ben Howard',         track: 'Esmerelda' }]
        end
      end

      context 'passed the :artists argument' do
        before(:each) do
          stub_get_url('spec', 'fixtures', 'ajax', 'no_more', 'liked_artists.html')
        end

        it 'returns an array of artist names' do
          artists = @scraper.likes :artists
          expect(artists).to eq [
            'PANTyRAiD',
            'Crystal Castles',
            'Kito & Reija Lee',
            'Portishead',
            'Avicii']
        end
      end

      context 'passed the :albums argument' do
        before(:each) do
          stub_get_url('spec', 'fixtures', 'ajax', 'no_more', 'liked_albums.html')
        end

        it 'returns an array of hashes with the artist and album names' do
          albums = @scraper.likes :albums
          expect(albums).to eq [
            { artist: 'Kito & Reija Lee',       album: 'Sweet Talk EP' },
            { artist: 'Justice',                album: 'Audio, Video, Disco.' },
            { artist: 'The Mountain Goats',     album: 'All Eternals Deck' },
            { artist: 'Explosions In The Sky',  album: 'All Of A Sudden I Miss Everyone' },
            { artist: 'The Black Keys',         album: 'Attack & Release' }]
        end
      end

      context 'passed the :stations argument' do
        before(:each) do
          stub_get_url('spec', 'fixtures', 'ajax', 'no_more', 'liked_stations.html')
        end

        it 'returns an array of station names' do
          stations = @scraper.likes :stations
          expect(stations).to eq [
            'Country Christmas Radio',
            'Pachanga Boys Radio',
            'Tycho Radio',
            'Bon Iver Radio',
            'Beach House Radio']
        end
      end
    end

    describe '#following' do
      before(:each) do
        stub_get_url('spec', 'fixtures', 'ajax', 'no_more', 'following.html')
      end

      it 'returns an array of people being following + metadata' do
        following = @scraper.following
        expect(following).to eq [
          { name: 'caleb',            webname: 'wakcamaro',        href: '/profile/wakcamaro' },
          { name: 'caleb_robert_97',  webname: 'caleb_robert_97',  href: '/profile/caleb_robert_97' },
          { name: 'Caleb Smith',      webname: 'caleb_smith_',     href: '/profile/caleb_smith_' },
          { name: 'Caleb Lalonde',    webname: 'caleb_lalonde',    href: '/profile/caleb_lalonde' },
          { name: 'Steve',            webname: 'stortiz4',         href: '/profile/stortiz4' },
          { name: 'Steve Ingals',     webname: 'ingalls_steve',    href: '/profile/ingalls_steve' },
          { name: 'Steve Boeckels',   webname: 'steve_boeckels',   href: '/profile/steve_boeckels' },
          { name: 'Steve D',          webname: 'steve_diamond',    href: '/profile/steve_diamond' },
          { name: 'Steve Orona',      webname: 'orona_steve',      href: '/profile/orona_steve' },
          { name: 'John',             webname: 'john_chretien',    href: '/profile/john_chretien' }]
      end
    end

    describe '#followers' do
      before(:each) do
        stub_get_url('spec', 'fixtures', 'ajax', 'no_more', 'followers.html')
      end

      it 'returns an array of followers + metadata' do
        followers = @scraper.followers
        expect(followers).to eq [
          { name: 'pandorastats',   webname: 'pandorastats',   href: '/profile/pandorastats' },
          { name: 'HowZat',         webname: 'stevierocksys',  href: '/profile/stevierocksys' },
          { name: 'pgil28',         webname: 'pgil28',         href: '/profile/pgil28' },
          { name: 'sexy bella :)',  webname: 'sexygirl43',     href: '/profile/sexygirl43' },
          { name: 'jhendrix3188',   webname: 'jhendrix3188',   href: '/profile/jhendrix3188' },
          { name: 'Murtada67',      webname: 'murtada67',      href: '/profile/murtada67' },
          { name: 'lochead',        webname: 'lochead',        href: '/profile/lochead' }]
      end
    end
  end
end

