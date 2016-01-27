# Pandata

Pandata is a Ruby 1.9+ library for downloading a user's Pandora.com data. This data includes:

- Likes (albums, artists, stations, tracks)
- Followers
- Following

**Pandata can only access public Pandora profiles.** This option can be changed in Pandora's settings.

Note: Scraping is a fragile task and Pandora can (and has) easily break this
gem. Version 2 of this gem represents the removal of Pandora's [feeds][1] feature.

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

    # Get liked tracks, artists + output as JSON.
    pandata my_webname -lL --json

    # Get all data and output to a file.
    pandata my_webname --all -o my_pandora_data.txt

### FAQ

#### Q: Pandata is not grabbing all my liked tracks on Pandora. What's up with that?!

First, for those coming from [pandify.com](http://pandify.com), Pandata is the
tool that actually grabs your Pandora data.

So, Pandora doesn't make it easy to retrieve users' data. This gem scrapes
public Pandora profiles by going through a few fake proxy accounts. These fake
accounts are shared between all Pandata users and it seems that Pandora now
prevents those accounts from seeing some data on the website:

![Unable to display thumb data.](https://raw.githubusercontent.com/ustasb/pandata/master/unable_to_display_data.png)

As a workaround, I tried using the same fake accounts via the mobile endpoints.
Pandora hasn't flagged the fake proxy accounts yet via this method. However, I've
noticed that if you try to scroll through some user's liked tracks on Pandora's
mobile app, the app will get stuck randomly and fail to load the next tracks.
The loading spinner will never stop:

![tconrad infinite feed](https://raw.githubusercontent.com/ustasb/pandata/master/tconrad_infinite_feed.png)

*The above is Tom Conrad's liked tracks mobile feed. He has 1200+ but the feed stops at around 185.*

Again, this only happens for some users and I can't do anything about it. If it
affects you, I'm sorry :(

[1]: http://www.pandora.com/feeds
[2]: http://rubydoc.info/gems/pandata/frames
