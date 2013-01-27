module Pandora
  URLS = {
    user_search:          "http://www.pandora.com/content/connect?searchString=%{searchString}",
    stations:             "http://www.pandora.com/content/stations?startIndex=%{nextStartIndex}&webname=%{webname}",
    bookmarked_tracks:    "http://www.pandora.com/content/bookmarked_tracks?trackStartIndex=%{nextStartIndex}&webname=%{webname}",
    bookmarked_artists:   "http://www.pandora.com/content/bookmarked_artists?artistStartIndex=%{nextStartIndex}&webname=%{webname}",
    liked_tracks:         "http://www.pandora.com/content/tracklikes?likeStartIndex=%{nextLikeStartIndex}&thumbStartIndex=%{nextThumbStartIndex}&webname=%{webname}",
    liked_artists:        "http://www.pandora.com/content/artistlikes?artistStartIndex=%{nextStartIndex}&webname=%{webname}",
    liked_stations:       "http://www.pandora.com/content/stationlikes?stationStartIndex=%{nextStartIndex}&webname=%{webname}",
    liked_albums:         "http://www.pandora.com/content/albumlikes?albumStartIndex=%{nextStartIndex}&webname=%{webname}",
    following:            "http://www.pandora.com/content/following?startIndex=%{nextStartIndex}&webname=%{webname}",
    followers:            "http://www.pandora.com/content/followers?startIndex=%{nextStartIndex}&webname=%{webname}"
  }
end
