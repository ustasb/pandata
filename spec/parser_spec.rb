require_relative '../lib/parser.rb'

describe Pandora::Parser do

  before(:all) do
    @parser = Pandora::Parser.new
  end

  describe '#get_webnames_from_search' do
    let(:html) { File.read(File.join('spec', 'fixtures', 'search_results_for_joe.html')) }

    it 'returns an array of webnames' do
      webnames = @parser.get_webnames_from_search html
      expect(webnames).to eq [
        'joe',
        'joe_maas',
        'joe_m_reyes',
        'joe_rybicki',
        'joe_biear',
        'batman-joe',
        'jedi_joe',
        'joe_carpenito',
        'joe_old',
        'rustin_joe',
        'joe_slavin',
        'explosivo_joe',
        'joe_tonda',
        'joe-phat']
    end
  end

  describe '#more_data_on_server?' do
    context 'when more data exists' do
      let(:bookmarked_tracks)   { File.read(File.join('spec', 'fixtures', 'bookmarked_tracks.html')) }
      let(:bookmarked_artists)  { File.read(File.join('spec', 'fixtures', 'bookmarked_artists.html')) }
      let(:liked_tracks)        { File.read(File.join('spec', 'fixtures', 'liked_tracks.html')) }
      let(:liked_artists)       { File.read(File.join('spec', 'fixtures', 'liked_artists.html')) }
      let(:liked_stations)      { File.read(File.join('spec', 'fixtures', 'liked_stations.html')) }
      let(:liked_albums)        { File.read(File.join('spec', 'fixtures', 'liked_albums.html')) }
      let(:followers)           { File.read(File.join('spec', 'fixtures', 'followers.html')) }
      let(:following)           { File.read(File.join('spec', 'fixtures', 'following.html')) }

      it 'returns the next indices to use to get the next set of data' do
        result = @parser.more_data_on_server? bookmarked_tracks
        expect(result).to eq({ nextStartIndex: 5 })

        result = @parser.more_data_on_server? bookmarked_artists
        expect(result).to eq({ nextStartIndex: 5 })

        result = @parser.more_data_on_server? liked_tracks
        expect(result).to eq({ nextLikeStartIndex: 0, nextThumbStartIndex: 10 })

        result = @parser.more_data_on_server? liked_artists
        expect(result).to eq({ nextStartIndex: 5 })

        result = @parser.more_data_on_server? liked_stations
        expect(result).to eq({ nextStartIndex: 5 })

        result = @parser.more_data_on_server? liked_albums
        expect(result).to eq({ nextStartIndex: 5 })

        result = @parser.more_data_on_server? followers
        expect(result).to eq({ nextStartIndex: 50 })

        result = @parser.more_data_on_server? following
        expect(result).to eq({ nextStartIndex: 50 })
      end
    end

    context 'when no more data exists' do
      let(:html1) { File.read(File.join('spec', 'fixtures', 'no_more_bookmarked_tracks.html')) }
      let(:html2) { File.read(File.join('spec', 'fixtures', 'stations.html')) }

      it 'returns false' do
        result = @parser.more_data_on_server? html1
        expect(result).to eq false

        result = @parser.more_data_on_server? html2
        expect(result).to eq false
      end
    end
  end

  describe '#infobox_each_link' do
    it 'accepts a block passing the title link and the subtitle link text' do
      html = File.read(File.join('spec', 'fixtures', 'bookmarked_tracks.html'))
      titles = []

      # Access the private method
      @parser.instance_eval do
        infobox_each_link(html) do |title, subtitle|
          titles.push title, subtitle
        end
      end

      expect(titles).to eq [
        'Cover Your Tracks',
        'A Boy and His Kite',
        'Royksopp Forever',
        'Royksopp',
        'Lucky You',
        'The National',
        'Welcome Home',
        'Radical Face',
        'Broadripple Is Burning (Daytrotter Sessions)',
        'Margot & The Nuclear So And So\'s']
    end
  end

  describe '#get_stations' do
    let(:html) { File.read(File.join('spec', 'fixtures', 'stations.html')) }

    it 'returns an array of station names' do
      stations = @parser.get_stations html
      expect(stations).to eq [
        'R&B / Soul Radio',
        'Reggae Radio',
        'Today\'s R&B and Hip Hop Hits Radio',
        'Today\'s R&B and Old School Radio',
        'Lenny Williams Radio',
        'Murs Radio',
        'R&B Love Songs Radio',
        'Contemporary Reggae Radio',
        'Neo-Soul Radio']
    end
  end

  describe '#get_bookmarked_tracks' do
    let(:html) { File.read(File.join('spec', 'fixtures', 'bookmarked_tracks.html')) }

    it 'returns an array of hashes with the artist and track names' do
      bookmarked_tracks = @parser.get_bookmarked_tracks html
      expect(bookmarked_tracks).to eq [
        { artist: 'A Boy and His Kite',                 track: 'Cover Your Tracks' },
        { artist: 'Royksopp',                           track: 'Royksopp Forever' },
        { artist: 'The National',                       track: 'Lucky You' },
        { artist: 'Radical Face',                       track: 'Welcome Home' },
        { artist: 'Margot & The Nuclear So And So\'s',  track: 'Broadripple Is Burning (Daytrotter Sessions)' }]
    end
  end

  describe '#get_bookmarked_artists' do
    let(:html) { File.read(File.join('spec', 'fixtures', 'bookmarked_artists.html')) }

    it 'returns an array of artist names' do
      bookmarked_artists = @parser.get_bookmarked_artists html
      expect(bookmarked_artists).to eq [
        'Trampled By Turtles',
        'Adele',
        'DJ Logic',
        'Whitley',
        'Mumford & Sons']
    end
  end

  describe '#get_liked_tracks' do
    let(:html) { File.read(File.join('spec', 'fixtures', 'liked_tracks.html')) }

    it 'returns an array of hashes with the artist and track names' do
      liked_tracks = @parser.get_liked_tracks html
      expect(liked_tracks).to eq [
        { artist: 'Of Monsters & Men',  track: 'Lakehouse' },
        { artist: 'Phoenix',            track: 'Lasso' },
        { artist: 'Sean Watkins',       track: 'Hello...Goodbye' },
        { artist: 'Paloma Faith',       track: 'My Legs Are Weak' },
        { artist: 'Ben Howard',         track: 'Esmerelda' }]
    end
  end

  describe '#get_liked_artists' do
    let(:html) { File.read(File.join('spec', 'fixtures', 'liked_artists.html')) }

    it 'returns an array of artist names' do
      liked_artists = @parser.get_liked_artists html
      expect(liked_artists).to eq [
        'PANTyRAiD',
        'Crystal Castles',
        'Kito & Reija Lee',
        'Portishead',
        'Avicii']
    end
  end

  describe '#get_liked_stations' do
    let(:html) { File.read(File.join('spec', 'fixtures', 'liked_stations.html')) }

    it 'returns an array of station names' do
      liked_stations = @parser.get_liked_stations html
      expect(liked_stations).to eq [
        'Country Christmas Radio',
        'Pachanga Boys Radio',
        'Tycho Radio',
        'Bon Iver Radio',
        'Beach House Radio']
    end
  end

  describe '#get_liked_albums' do
    let(:html) { File.read(File.join('spec', 'fixtures', 'liked_albums.html')) }

    it 'returns an array of hashes with the artist and album names' do
      liked_albums = @parser.get_liked_albums html
      expect(liked_albums).to eq [
        { artist: 'Kito & Reija Lee',       album: 'Sweet Talk EP' },
        { artist: 'Justice',                album: 'Audio, Video, Disco.' },
        { artist: 'The Mountain Goats',     album: 'All Eternals Deck' },
        { artist: 'Explosions In The Sky',  album: 'All Of A Sudden I Miss Everyone' },
        { artist: 'The Black Keys',         album: 'Attack & Release' }]
    end
  end

  describe '#get_following' do
    let(:html) { File.read(File.join('spec', 'fixtures', 'all_following.html')) }

    it 'returns an array of people being following + metadata' do
      following = @parser.get_following html
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

  describe '#get_followers' do
    let(:html) { File.read(File.join('spec', 'fixtures', 'all_followers.html')) }

    it 'returns an array of followers + metadata' do
      followers = @parser.get_followers html
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
