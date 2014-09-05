module Pandata
  # Number of results to get from a feeds.pandora.com URL.
  MAX_RESULTS = 100_000  # Get everything...

  # URLs to Pandora's data!
  DATA_FEED_URLS = {
    user_search:          'http://www.pandora.com/content/connect?searchString=%{searchString}',
    recent_activity:      'http://feeds.pandora.com/feeds/people/%{webname}/recentactivity.xml',
    playing_station:      'http://feeds.pandora.com/feeds/people/%{webname}/nowplaying.xml',
    stations:             "http://feeds.pandora.com/feeds/people/%{webname}/stations.xml?max=#{MAX_RESULTS}",
    bookmarked_tracks:    "http://feeds.pandora.com/feeds/people/%{webname}/favorites.xml?max=#{MAX_RESULTS}",
    bookmarked_artists:   "http://feeds.pandora.com/feeds/people/%{webname}/favoriteartists.xml?max=#{MAX_RESULTS}",
    liked_tracks:         'http://www.pandora.com/content/mobile/profile_likes_track.vm?likeStartIndex=%{nextLikeStartIndex}&thumbStartIndex=%{nextThumbStartIndex}&webname=%{webname}&pat=%{pat}',
    liked_artists:        'http://www.pandora.com/content/artistlikes?artistStartIndex=%{nextStartIndex}&webname=%{webname}',
    liked_stations:       'http://www.pandora.com/content/stationlikes?stationStartIndex=%{nextStartIndex}&webname=%{webname}',
    liked_albums:         'http://www.pandora.com/content/albumlikes?albumStartIndex=%{nextStartIndex}&webname=%{webname}',
    following:            'http://www.pandora.com/content/following?startIndex=%{nextStartIndex}&webname=%{webname}',
    followers:            'http://www.pandora.com/content/followers?startIndex=%{nextStartIndex}&webname=%{webname}'
  }
end
