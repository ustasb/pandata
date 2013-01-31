require_relative '../lib/pandata/data_formatter'

ARTISTS = %w{ Mogwai Eminem Portishead Eminem Avicii Ladytron Ted }
TRACKS = [
  { track: 'Love Story',    artist: 'Foobar' },
  { track: 'Love Story 2',  artist: 'Foobar' },
  { track: 'Without You',   artist: 'Foobar' },
  { track: 'Yolo',          artist: 'Solo' },
  { track: 'Kiss It',       artist: 'Baz' },
  { track: 'Consent',       artist: 'Baz' },
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

  describe '#uniq_sort_list' do
    it 'removes all duplicates, sorts and formats like #list does' do
      str = @parser.uniq_sort_list(ARTISTS)
      expect(str).to eq <<-END
  - Avicii
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

  describe '#custom_sort', "ignores the initial 'The' word when sorting strings" do
    it 'sorts arrays' do
      words = ['Skittle', 'Apple', 'The Cat', 'the Dog', 'The Banana']
      sorted_words = @parser.send(:custom_sort, words)
      expect(sorted_words).to eq ['Apple', 'The Banana', 'The Cat', 'the Dog', 'Skittle']
    end

    it 'sorts hashes by key' do
      words = { 'Skittle' => {}, 'Apple' => {}, 'The Cat' => {}, 'the Dog' => {}, 'The Banana' => {} }
      sorted_words = @parser.send(:custom_sort, words)
      expect(sorted_words.keys).to eq ['Apple', 'The Banana', 'The Cat', 'the Dog', 'Skittle']
    end
  end

  describe '#artists_items' do
    it 'sorts by artist name, indenting items under respective artists' do
      str = @parser.send(:artists_items, TRACKS, :track)
      expect(str).to eq <<-END
  - Baz
      - Consent
      - Kiss It
  - Foobar
      - Love Story
      - Love Story 2
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