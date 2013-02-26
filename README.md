# Pandata

Pandata is a Ruby library for downloading a user's Pandora data. This data includes:

- Playing Station *
- Recent Activity *
- Stations *
- Bookmarks (tracks, artists) *
- Likes (tracks, artists, albums, stations)
- Followers
- Following

Where possible, Pandora [feeds][1] are used (indicated by an * above).

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

First, create a new Pandata scraper for some user:

    # Scraper.get takes either an email or webname.
    scraper = Pandata::Scraper.get('john@example.com')

Next, start scraping!

    # Get only liked tracks
    likes = scraper.likes :tracks
    
    # Get all bookmarks (tracks and artists)
    bookmarks = scraper.bookmarks :all
    
    # Get all stations
    stations = scraper.stations
    
    # Get all followers
    followers = scraper.followers

Please see the documentation for more information.

### As a Command-Line Tool

    pandata <email|webname> [options]

**Examples:**

    pandata john@example.com --liked_tracks

    # Liked tracks, artists and bookmarked tracks + output as JSON
    pandata my_webname -lLb --json
    
    # Download EVERYTHING!
    pandata my_webname --all

**Options:**

        --all                        Get all data
    -a, --recent_activity            Get recent activity
    -B, --bookmarked_artists         Get all bookmarked artists
    -b, --bookmarked_tracks          Get all bookmarked tracks
    -F, --followers                  Get all ID's followers
    -f, --following                  Get all users being followed by ID
    -j, --json                       Return the results as JSON
    -L, --liked_artists              Get all liked artists
    -l, --liked_tracks               Get all liked tracks
    -m, --liked_albums               Get all liked albums
    -n, --liked_stations             Get all liked stations
    -S, --playing_station            Get currently playing station
    -s, --stations                   Get all stations


[1]: http://www.pandora.com/feeds
