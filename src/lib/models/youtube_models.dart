class VideoSearchResult {
  String? nextPageToken;
  List<YoutubeVideo>? items;

  VideoSearchResult({this.nextPageToken, this.items});

  VideoSearchResult.fromJson(Map<String, dynamic> json) {
    nextPageToken = json['nextPageToken'];
    if (json['items'] != null) {
      items = <YoutubeVideo>[];
      json['items'].forEach((v) {
        items!.add(new YoutubeVideo.fromJson(v));
      });
    }
  }
}

class YoutubeVideo {
  Id? id;
  Snippet? snippet;

  YoutubeVideo({this.id, this.snippet});

  YoutubeVideo.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? new Id.fromJson(json['id']) : null;
    snippet =
        json['snippet'] != null ? new Snippet.fromJson(json['snippet']) : null;
  }
}

class Id {
  String? videoId;

  Id({this.videoId});

  Id.fromJson(Map<String, dynamic> json) {
    videoId = json['videoId'];
  }
}

class Snippet {
  String? publishedAt;
  String? channelId;
  String? title;
  String? description;
  Thumbnails? thumbnails;
  String? channelTitle;

  //Local property/variable
  String? channelImageURL;

  Snippet(
      {this.publishedAt,
      this.channelId,
      this.title,
      this.description,
      this.thumbnails,
      this.channelTitle});

  Snippet.fromJson(Map<String, dynamic> json) {
    publishedAt = json['publishedAt'];
    channelId = json['channelId'];
    title = json['title'];
    description = json['description'];
    thumbnails = json['thumbnails'] != null
        ? new Thumbnails.fromJson(json['thumbnails'])
        : null;
    channelTitle = json['channelTitle'];
  }
}

class Thumbnails {
  Thumbnail? medium;
  Thumbnail? high;

  Thumbnails({this.medium, this.high});

  Thumbnails.fromJson(Map<String, dynamic> json) {
    medium =
        json['medium'] != null ? new Thumbnail.fromJson(json['medium']) : null;
    high = json['high'] != null ? new Thumbnail.fromJson(json['high']) : null;
  }
}

class Thumbnail {
  String? url;

  Thumbnail({this.url});

  Thumbnail.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }
}

//Channel Model

class ChannelSearchResult {
  List<Channel>? items;

  ChannelSearchResult({this.items});

  ChannelSearchResult.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Channel>[];
      json['items'].forEach((v) {
        items!.add(new Channel.fromJson(v));
      });
    }
  }
}

class Channel {
  String? id;
  Snippet? snippet;
  Statistics? statistics;

  Channel({this.id, this.snippet, this.statistics});

  Channel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    snippet =
        json['snippet'] != null ? new Snippet.fromJson(json['snippet']) : null;
    statistics = json['statistics'] != null
        ? new Statistics.fromJson(json['statistics'])
        : null;
  }
}

class Statistics {
  String? viewCount;
  String? subscriberCount;

  Statistics({this.viewCount, this.subscriberCount});

  Statistics.fromJson(Map<String, dynamic> json) {
    viewCount = json['viewCount'];
    subscriberCount = json['subscriberCount'];
  }
}
