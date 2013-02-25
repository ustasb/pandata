require_relative '../lib/pandata/data_formatter'

ARTISTS = %w{ Mogwai Eminem Portishead Eminem Avicii Ladytron Ted }
TRACKS = [
  { track: 'Love Story',    artist: 'Foobar' },
  { track: 'love story 2',  artist: 'Foobar' },
  { track: 'Without You',   artist: 'Foobar' },
  { track: 'The Love',      artist: 'Foobar' },
  { track: 'Yolo',          artist: 'Solo' },
  { track: 'Kiss It',       artist: 'Baz' },
  { track: 'The Awe',       artist: 'Baz' },
  { track: 'The Old Life',  artist: 'Baz' },
  { track: 'consent',       artist: 'Baz' },
  { track: 'Zebra Love',    artist: 'Baz' },
  { track: 'Him and Her',   artist: 'Qux' },
  { track: 'Bromance',      artist: 'Qux' }
]
FOLLOWERS = [
  { name: 'Zat',      webname: 'rocksys',   href: '/profile/rocksys' },
  { name: 'gil',      webname: 'pgil',      href: '/profile/pgil' },
  { name: 'hendrix',  webname: 'jhendrix',  href: '/profile/jhendrix' },
  { name: 'Murtada',  webname: 'murtada',   href: '/profile/murtada' },
  { name: 'loc',      webname: 'loc',       href: '/profile/loc' }
]

describe Pandata::DataFormatter do
  before(:all) do
    @parser = Pandata::DataFormatter.new
  end

  describe '#list' do
    it 'formats an array as a multiline string' do
      str = @parser.list(ARTISTS)
      expect(str).to eq <<-END
  - Mogwai
  - Eminem
  - Portishead
  - Eminem
  - Avicii
  - Ladytron
  - Ted
      END
    end
  end

  describe '#sort_list' do
    it 'sorts and formats like #list does' do
      str = @parser.sort_list(ARTISTS)
      expect(str).to eq <<-END
  - Avicii
  - Eminem
  - Eminem
  - Ladytron
  - Mogwai
  - Portishead
  - Ted
      END
    end
  end

  describe '#followx' do
    it 'lists the user\'s stats and sorts by webname' do
      str = @parser.followx(FOLLOWERS)
      expect(str).to eq <<-END
  - name: hendrix
    webname: jhendrix
    href: /profile/jhendrix
  - name: loc
    webname: loc
    href: /profile/loc
  - name: Murtada
    webname: murtada
    href: /profile/murtada
  - name: gil
    webname: pgil
    href: /profile/pgil
  - name: Zat
    webname: rocksys
    href: /profile/rocksys
      END
    end
  end

  describe '#custom_sort', "case insensitive + ignores the initial 'The' word when sorting strings" do
    it 'sorts arrays' do
      words = ['Skittle', 'apple', 'The Cat', 'the Dog', 'The banana']
      sorted_words = @parser.send(:custom_sort, words)
      expect(sorted_words).to eq ['apple', 'The banana', 'The Cat', 'the Dog', 'Skittle']
    end

    it 'sorts hashes by key' do
      words = { 'Skittle' => {}, 'Apple' => {}, 'The Cat' => {}, 'the Dog' => {}, 'The Banana' => {} }
      sorted_words = @parser.send(:custom_sort, words)
      expect(sorted_words.keys).to eq ['Apple', 'The Banana', 'The Cat', 'the Dog', 'Skittle']
    end
  end

  describe '#artists_items' do
    it "ignores 'The', is case insensitive and sorts by artist name, indenting items under owning artist" do
      str = @parser.send(:artists_items, TRACKS, :track)
      expect(str).to eq <<-END
  - Baz
      - The Awe
      - consent
      - Kiss It
      - The Old Life
      - Zebra Love
  - Foobar
      - The Love
      - Love Story
      - love story 2
      - Without You
  - Qux
      - Bromance
      - Him and Her
  - Solo
      - Yolo
      END
    end
  end
end
