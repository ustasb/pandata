require 'spec_helper'
require 'pandata/scraper'

describe Pandata::Scraper do
  before(:each) do
    Pandata::Downloader.stub(:read_page).and_return read_path(path)
  end

  describe 'Scraper.get' do
    context "when a webname exactly matches the user's search" do
      let(:path) { 'fixtures/ajax/no_more/search_results_for_lols.html' }

      it "returns a new Scraper instance" do
        result = Pandata::Scraper.get('lols')

        expect(result.class).to eq Pandata::Scraper
        expect(result.webname).to eq 'lols'
      end
    end

    context 'when no matching webnames are found' do
      let(:path) { 'fixtures/ajax/show_more/search_results_for_skittle.html' }

      it 'returns an array of similar webnames' do
        result = Pandata::Scraper.get('skittle')
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
          'rawr_skittle_lover'
        ]
      end
    end
  end

  describe 'a Scraper instance' do
    let(:scraper) { Pandata::Scraper.send(:new, 'pandorastats') }

    describe '#recent_activity' do
      let(:path) { 'fixtures/feeds/recent_activity.xml' }

      it 'returns an array of activity names' do
        activity = scraper.recent_activity
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
          'Drake Radio'
        ]
      end
    end

    describe '#playing_station' do
      let(:path) { 'fixtures/feeds/station_now_playing.xml' }

      it 'returns the name of the currently playing station' do
        station = scraper.playing_station
        expect(station).to eq 'Drake Radio'
      end
    end

    describe '#stations' do
      let(:path) { 'fixtures/feeds/stations.xml' }

      it 'returns an array of station names' do
        stations = scraper.stations
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
          'pandorastats\'s QuickMix'
        ]
      end
    end

    describe '#bookmarks' do
      context 'passed the :tracks argument' do
        let(:path) { 'fixtures/feeds/bookmarked_tracks.xml' }

        it 'returns an array of hashes with track and artist names' do
          tracks = scraper.bookmarks(:tracks)
          expect(tracks).to eq [
            { artist: 'A Boy and His Kite',                 track: 'Cover Your Tracks' },
            { artist: 'Royksopp',                           track: 'Royksopp Forever' },
            { artist: 'The National',                       track: 'Lucky You' },
            { artist: 'Radical Face',                       track: 'Welcome Home' },
            { artist: "Margot & The Nuclear So And So's",   track: 'Broadripple Is Burning (Daytrotter Sessions)' }
          ]
        end
      end

      context 'passed the :artists argument' do
        let(:path) { 'fixtures/feeds/bookmarked_artists.xml' }

        it 'returns an array of artist names' do
          artists = scraper.bookmarks(:artists)
          expect(artists).to eq [
            'Trampled By Turtles',
            'Adele',
            'DJ Logic',
            'Whitley',
            'Mumford & Sons'
          ]
        end
      end
    end

    describe '#likes' do
      context 'passed the :tracks argument' do
        let(:path) { 'fixtures/ajax/no_more/mobile/liked_tracks.html' }

        it 'returns an array of hashes with track and artist names' do
          tracks = scraper.likes(:tracks)
          expect(tracks).to eq [
            { artist: "The Rock Heroes",    track: "All Summer Long" },
            { artist: "Feist",              track: "I Feel It All" },
            { artist: "Montgomery Gentry",  track: "Hell Yeah" },
            { artist: "Saving Abel",        track: "Addicted" },
            { artist: "The Verve",          track: "Bitter Sweet Symphony" },
            { artist: "India Arie",         track: "The Heart Of The Matter" },
            { artist: "Fauxliage",          track: "Let It Go" },
            { artist: "Jem",                track: "Save Me" }
          ]
        end
      end

      context 'passed the :artists argument' do
        let(:path) { 'fixtures/ajax/no_more/liked_artists.html' }

        it 'returns an array of artist names' do
          artists = scraper.likes(:artists)
          expect(artists).to eq [
            'PANTyRAiD',
            'Crystal Castles',
            'Kito & Reija Lee',
            'Portishead',
            'Avicii'
          ]
        end
      end

      context 'passed the :albums argument' do
        let(:path) { 'fixtures/ajax/no_more/liked_albums.html' }

        it 'returns an array of hashes with the artist and album names' do
          albums = scraper.likes(:albums)
          expect(albums).to eq [
            { artist: 'Kito & Reija Lee',       album: 'Sweet Talk EP' },
            { artist: 'Justice',                album: 'Audio, Video, Disco.' },
            { artist: 'The Mountain Goats',     album: 'All Eternals Deck' },
            { artist: 'Explosions In The Sky',  album: 'All Of A Sudden I Miss Everyone' },
            { artist: 'The Black Keys',         album: 'Attack & Release' }
          ]
        end
      end

      context 'passed the :stations argument' do
        let(:path) { 'fixtures/ajax/no_more/liked_stations.html' }

        it 'returns an array of station names' do
          stations = scraper.likes(:stations)
          expect(stations).to eq [
            'Country Christmas Radio',
            'Pachanga Boys Radio',
            'Tycho Radio',
            'Bon Iver Radio',
            'Beach House Radio'
          ]
        end
      end
    end

    describe '#following' do
      let(:path) { 'fixtures/ajax/no_more/following.html' }

      it 'returns an array of people being followed + metadata' do
        following = scraper.following
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
          { name: 'John',             webname: 'john_chretien',    href: '/profile/john_chretien' }
        ]
      end
    end

    describe '#followers' do
      let(:path) { 'fixtures/ajax/no_more/followers.html' }

      it 'returns an array of followers + metadata' do
        followers = scraper.followers
        expect(followers).to eq [
          { name: 'pandorastats',   webname: 'pandorastats',   href: '/profile/pandorastats' },
          { name: 'HowZat',         webname: 'stevierocksys',  href: '/profile/stevierocksys' },
          { name: 'pgil28',         webname: 'pgil28',         href: '/profile/pgil28' },
          { name: 'sexy bella :)',  webname: 'sexygirl43',     href: '/profile/sexygirl43' },
          { name: 'jhendrix3188',   webname: 'jhendrix3188',   href: '/profile/jhendrix3188' },
          { name: 'Murtada67',      webname: 'murtada67',      href: '/profile/murtada67' },
          { name: 'lochead',        webname: 'lochead',        href: '/profile/lochead' }
        ]
      end
    end

  end
end
