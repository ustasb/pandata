# Pandata

Pandata is a Ruby 1.9+ library for downloading a user's Pandora.com data. This data includes:

- Playing Station *
- Recent Activity *
- Stations *
- Bookmarks (artists, tracks) *
- Likes (albums, artists, stations, tracks)
- Followers
- Following

Where possible, Pandora [feeds][1] are used (indicated by an * above).

**Pandata can only access public Pandora profiles.** This option can be changed in Pandora's settings.

## Installing

Pandata is a Ruby gem. To install, execute:

    gem install pandata

This also installs a command-line tool called 'pandata'.

## Usage

Pandata can be used as a Ruby library or command-line tool.

To identify a user, you must supply either an email address or a webname.

A **webname** is what Pandora uses to identify a user and it remains constant even if the user ties a new email address to their Pandora account.
To find your webname, go to 'My Profile' and you'll see your webname in the URL. For example:

pandora.com/profile/\<my_webname\>

### As a Library

First, create a new Pandata scraper for a user:

    require 'pandata'
    
    # Scraper.get takes either an email or a webname.
    # Returns an array of similar webnames if no match is found.
    johns_scraper = Pandata::Scraper.get('john@example.com')

Next, start scraping!

    # Get only liked tracks
    likes = johns_scraper.likes(:tracks)

    # Get all bookmarks (artists and tracks)
    bookmarks = johns_scraper.bookmarks

    # Get all stations
    stations = johns_scraper.stations

    # Get all followers
    followers = johns_scraper.followers

For more information, see the [documentation][2] for Pandata::Scraper.

### As a Command-Line Tool

All output is sorted alphabetically, duplicates are removed and tracks are grouped under their owning artist.

    pandata <email|webname> [options]

**Options:**

For an up-to-date list, check out:

    pandata --help

**Examples:**

    pandata john@example.com --liked_tracks

    # Get liked tracks, artists and bookmarked tracks + output as JSON.
    pandata my_webname -lLb --json

    # Get all data and output to a file.
    pandata my_webname --all -o my_pandora_data.txt

[1]: http://www.pandora.com/feeds
[2]: http://rubydoc.info/gems/pandata/frames
