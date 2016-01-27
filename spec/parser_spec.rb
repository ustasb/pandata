require 'spec_helper'
require 'pandata/parser'

describe Pandata::Parser do
  let(:liked_albums_html)   { read_path('fixtures/ajax/show_more/liked_albums.html') }
  let(:liked_tracks_html)   { read_path('fixtures/ajax/show_more/mobile/liked_tracks.html') }
  let(:liked_artists_html)  { read_path('fixtures/ajax/show_more/liked_artists.html') }
  let(:liked_stations_html) { read_path('fixtures/ajax/show_more/liked_stations.html') }
  let(:liked_albums_html)   { read_path('fixtures/ajax/show_more/liked_albums.html') }

  let(:parser) { Pandata::Parser.new }

  describe '#get_webnames_from_search' do
    let(:html) { read_path('fixtures/ajax/show_more/search_results_for_joe.html') }

    it 'returns an array of webnames' do
      webnames = parser.get_webnames_from_search(html)
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
        'joe-phat'
      ]
    end
  end

  describe '#get_next_data_indices' do
    context 'when more data exists on the server' do
      let(:followers) { read_path('fixtures/ajax/show_more/followers.html') }
      let(:following) { read_path('fixtures/ajax/show_more/following.html') }

      it 'returns the indices to use in the next request to get the next set of data' do
        result = parser.get_next_data_indices(liked_tracks_html)
        expect(result).to eq({ nextLikeStartIndex: 0, nextThumbStartIndex: 20 })

        result = parser.get_next_data_indices(liked_artists_html)
        expect(result).to eq({ nextStartIndex: 5 })

        result = parser.get_next_data_indices(liked_stations_html)
        expect(result).to eq({ nextStartIndex: 5 })

        result = parser.get_next_data_indices(liked_albums_html)
        expect(result).to eq({ nextStartIndex: 5 })

        result = parser.get_next_data_indices(followers)
        expect(result).to eq({ nextStartIndex: 50 })

        result = parser.get_next_data_indices(following)
        expect(result).to eq({ nextStartIndex: 50 })
      end
    end

    context 'when no more data exists' do
      let(:html) { read_path('fixtures/ajax/no_more/mobile/liked_tracks.html') }

      it 'returns false' do
        result = parser.get_next_data_indices(html)
        expect(result).to eq false
      end
    end
  end

  describe '#infobox_each_link' do
    it 'accepts a block passing the title link and the subtitle link text' do
      albums = liked_albums_html
      all_titles = []

      parser.instance_eval do
        infobox_each_link(albums) do |title, subtitle|
          all_titles.push(title, subtitle)
        end
      end

      expect(all_titles).to eq [
        'Sweet Talk EP',
        'Kito & Reija Lee',
        'Audio, Video, Disco.',
        'Justice',
        'All Eternals Deck',
        'The Mountain Goats',
        'All Of A Sudden I Miss Everyone',
        'Explosions In The Sky',
        'Attack & Release',
        'The Black Keys'
      ]
    end
  end

  describe '#doublelink_each_link' do
    it 'accepts a block passing the title link and the subtitle link text' do
      tracks = liked_tracks_html
      all_titles = []

      parser.instance_eval do
        doublelink_each_link(tracks) do |title, subtitle|
          all_titles.push(title, subtitle)
        end
      end

      expect(all_titles).to eq [
        "Chitlins Con Carne",
        "by Stevie Ray Vaughan",
        "Rock You Like A Hurricane (Live)",
        "by Scorpions",
        "Evil",
        "by William Clarke",
        "Blues For Lost Days (Live)",
        "by John Mayall",
        "As The Years Go Passing By (Live)",
        "by The Mannish Boys",
        "Let's Cool One (1958)",
        "by Thelonious Monk",
        "Breathe",
        "by Bjorn Akesson",
        "Greatest DJ (Radio Edit)",
        "by twoloud",
        "Nobody's Fault But My Own",
        "by Lil' Ed & The Blues Imperials",
        "Dog House Blues",
        "by Larry Garner"
      ]
    end
  end

  describe '#get_liked_tracks' do
    it 'returns an array of hashes with the artist and track names' do
      tracks = parser.get_liked_tracks(liked_tracks_html)
      expect(tracks).to eq [
        { artist: "Stevie Ray Vaughan",             track: "Chitlins Con Carne"},
        { artist: "Scorpions",                      track: "Rock You Like A Hurricane (Live)" },
        { artist: "William Clarke",                 track: "Evil" },
        { artist: "John Mayall",                    track: "Blues For Lost Days (Live)" },
        { artist: "The Mannish Boys",               track: "As The Years Go Passing By (Live)" },
        { artist: "Thelonious Monk",                track: "Let's Cool One (1958)" },
        { artist: "Bjorn Akesson",                  track: "Breathe" },
        { artist: "twoloud",                        track: "Greatest DJ (Radio Edit)" },
        { artist: "Lil' Ed & The Blues Imperials",  track: "Nobody's Fault But My Own" },
        { artist: "Larry Garner",                   track: "Dog House Blues" }
      ]
    end
  end

  describe '#get_liked_artists' do
    it 'returns an array of artist names' do
      artists = parser.get_liked_artists(liked_artists_html)
      expect(artists).to eq [
        'PANTyRAiD',
        'Crystal Castles',
        'Kito & Reija Lee',
        'Portishead',
        'Avicii'
      ]
    end
  end

  describe '#get_liked_stations' do
    it 'returns an array of station names' do
      stations = parser.get_liked_stations(liked_stations_html)
      expect(stations).to eq [
        'Country Christmas Radio',
        'Pachanga Boys Radio',
        'Tycho Radio',
        'Bon Iver Radio',
        'Beach House Radio'
      ]
    end
  end

  describe '#get_liked_albums' do
    it 'returns an array of hashes with the artist and album names' do
      albums = parser.get_liked_albums(liked_albums_html)
      expect(albums).to eq [
        { artist: 'Kito & Reija Lee',       album: 'Sweet Talk EP' },
        { artist: 'Justice',                album: 'Audio, Video, Disco.' },
        { artist: 'The Mountain Goats',     album: 'All Eternals Deck' },
        { artist: 'Explosions In The Sky',  album: 'All Of A Sudden I Miss Everyone' },
        { artist: 'The Black Keys',         album: 'Attack & Release' }
      ]
    end
  end

  describe '#get_following' do
    let(:html) { read_path('fixtures/ajax/no_more/following.html') }

    it 'returns an array of people being followed + metadata' do
      following = parser.get_following(html)
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

  describe '#get_followers' do
    let(:html) { read_path('fixtures/ajax/no_more/followers.html') }

    it 'returns an array of followers + metadata' do
      followers = parser.get_followers(html)
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
