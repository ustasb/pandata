require_relative 'spec_helper'
require 'pandata/cli'

describe Pandata::CLI do

  before do
    described_class.any_instance.stub(:update_progress)
  end

  describe '--version' do
    let(:argv) { ['--version'] }

    it 'logs the Pandata version' do
      STDOUT.should_receive(:puts).with Pandata::Version::STRING
      described_class.scrape(argv)
    end
  end

  describe '--help' do
    let(:argv) { ['--help'] }

    it 'logs the Pandata help' do
      STDOUT.should_receive(:puts).with(/Pandata: A tool for downloading.*/)
      described_class.scrape(argv)
    end
  end

  context 'user cannot be found' do
    context 'no similar webnames are found' do
      let(:argv) { %w{ invalidzz -l } }

      it 'displays a "no matches found" message' do
        VCR.use_cassette('no_similar_webnames') do
          STDOUT.should_receive(:puts).with("No exact match for 'invalidzz'.")
          expect { described_class.scrape(argv) }.to raise_error(Pandata::PandataError)
        end
      end
    end

    context 'similar webnames are found' do
      let(:argv) { %w{ swedish -l } }

      it 'displays a list of similar webnames' do
        VCR.use_cassette('many_similar_webnames') do
          STDOUT.should_receive(:puts).with("No exact match for 'swedish'.")
          STDOUT.should_receive(:puts).with <<-END

Webname results for 'swedish':
  - edwardgarcia1999
  - oskar.tegni
  - swedish_fish_09
  - parsa_aalamrezaieh
  - magickiwi14
  - swedish_gorilla
  - swedish_chic
  - swedish_lotty
  - swedish_engineer
  - swedish_dawl
  - swedish_fush
  - swedish_vikings
  - swedish_chic_29
  - swedish_and_proud
  - swedish_queen
          END
          expect { described_class.scrape(argv) }.to raise_error(Pandata::PandataError)
        end
      end
    end
  end

  context 'user is found' do
    let(:webname) { 'tconrad' }

    after(:each) do
      STDOUT.should_receive(:puts).with(
        File.read relative_path("fixtures/data/#{cassette}")
      )
      VCR.use_cassette(cassette) { described_class.scrape(argv) }
    end

    describe '--bookmarked_artists' do
      let(:cassette) { 'tconrad_bookmarked_artists' }
      let(:argv) { [webname, '--bookmarked_artists'] }

      it 'logs the bookmarked artists' do; end
    end

    describe '--bookmarked_tracks' do
      let(:cassette) { 'tconrad_bookmarked_tracks' }
      let(:argv) { [webname, '--bookmarked_tracks'] }

      it 'logs the bookmarked tracks' do; end
    end

    describe '--followers' do
      let(:cassette) { 'tconrad_followers' }
      let(:argv) { [webname, '--followers'] }

      it 'logs the followers' do; end
    end

    describe '--following' do
      let(:cassette) { 'tconrad_following' }
      let(:argv) { [webname, '--following'] }

      it 'logs the following users' do; end
    end

    describe '--liked_artists' do
      let(:cassette) { 'tconrad_liked_artists' }
      let(:argv) { [webname, '--liked_artists'] }

      it 'logs the liked artists' do; end
    end

    describe '--liked_tracks' do
      let(:cassette) { 'tconrad_liked_tracks' }
      let(:argv) { [webname, '--liked_tracks'] }

      it 'logs the liked tracks' do; end
    end

    describe '--liked_albums' do
      let(:cassette) { 'tconrad_liked_albums' }
      let(:argv) { [webname, '--liked_albums'] }

      it 'logs the liked albums' do; end
    end

    describe '--liked_stations' do
      let(:cassette) { 'tconrad_liked_stations' }
      let(:argv) { [webname, '--liked_stations'] }

      it 'logs the liked stations' do; end
    end

    describe '--stations' do
      let(:cassette) { 'tconrad_stations' }
      let(:argv) { [webname, '--stations'] }

      it 'logs the stations' do; end
    end

    describe '--all' do
      let(:cassette) { 'tconrad_all' }
      let(:argv) { [webname, '--all'] }

      it 'logs all available Pandora data' do; end
    end

  end
end
