module Pandata
  # URLs to Pandora's data!
  DATA_FEED_URLS = {
    user_search:          'http://www.pandora.com/content/connect?searchString=%{searchString}',
    liked_tracks:         'http://www.pandora.com/content/mobile/profile_likes_track.vm?likeStartIndex=%{nextLikeStartIndex}&thumbStartIndex=%{nextThumbStartIndex}&webname=%{webname}&pat=%{pat}',
    liked_artists:        'http://www.pandora.com/content/artistlikes?artistStartIndex=%{nextStartIndex}&webname=%{webname}',
    liked_stations:       'http://www.pandora.com/content/stationlikes?stationStartIndex=%{nextStartIndex}&webname=%{webname}',
    liked_albums:         'http://www.pandora.com/content/albumlikes?albumStartIndex=%{nextStartIndex}&webname=%{webname}',
    following:            'http://www.pandora.com/content/following?startIndex=%{nextStartIndex}&webname=%{webname}',
    followers:            'http://www.pandora.com/content/followers?startIndex=%{nextStartIndex}&webname=%{webname}'
  }
end
