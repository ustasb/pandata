# Pandata

Pandata is a Ruby library for downloading a user's Pandora data. This data includes:

- Playing Station *
- Recent Activity *
- Stations *
- Bookmarks (tracks, artists) *
- Likes (tracks, artists, albums, stations)
- Followers
- Following

Where possible, Pandora [feeds][1] are used (indicated by the * above).

## Installing

Pandata is a Ruby gem. To install, execute:

    gem install pandata

This also installs a command-line tool called 'pandata'.

## Usage

Pandata can be used as a library or command-line too

But first, what's a **webname**? It's what Pandora uses internally to identify a user and remains constant even if the user ties a new email to their Pandora account.
To find yours, go to 'My Profile' and you'll see your webname in the URL:

pandora.com/profile/**webname**

### As a Library



### As a Command-Line Tool





**Syntax:**

    pandata <email|webname> [options]

The first argument can be either an email associated with a Pandora account, or
a Pandora webname. A webname is what Pandora uses to identify a user and
can be found in Pandora's URL: pandora.com/profile/\<my_webname\>

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
