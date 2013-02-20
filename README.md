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

This first argument can be either an email associated with a Pandora account or
a Pandora webname. The Pandora webname is what Pandora uses to identify you and
can be found in Pandora's URL: pandora.com/profile/my_web_name

Usage Examples:

    pandata tconrad --liked_tracks

    ## Output as JSON
    pandata tconrad --liked_tracks --json
