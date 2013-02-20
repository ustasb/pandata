#Pandata (WIP)

A tool for downloading Pandora data. This includes:

- Playing Station
- Recent Activity
- Stations
- Bookmarks (tracks, artists)
- Likes (tracks, artists, albums, stations)
- Followers
- Following

## Usage

Pandata is a Ruby gem. To install, execute:

    gem install pandata

This will install Pandata as a command-line tool called 'pandata'.

The first argument can be either an email associated with a Pandora account, or
a Pandora webname. A webname is what Pandora uses to identify a user and
can be found in Pandora's URL: pandora.com/profile/*\<my_web_name\>*

Usage:

    pandata <email|webname> [options]

Examples:

    pandata john@example.com --liked_tracks

    # Download EVERYTHING!
    pandata my_webname --all

    # Liked tracks, artists and bookmarked tracks + output as JSON
    pandata my_webname -lLb --json

Options:

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
