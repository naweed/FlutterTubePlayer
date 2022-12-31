import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:tube_player/app_constants.dart';
import 'package:tube_player/models/youtube_models.dart';

class YoutubeApiService {
  late Dio _httpClient;
  late Options _cacheOptions;
  late DioCacheManager _dioCacheManager;

  YoutubeApiService() {
    _dioCacheManager = DioCacheManager(CacheConfig());
    _cacheOptions = buildCacheOptions(Duration(hours: 8));

    _httpClient = Dio();
    _httpClient.options.baseUrl = Constants.ApiServiceURL;
    _httpClient.interceptors.add(_dioCacheManager.interceptor);
  }

  Future<VideoSearchResult> searchVideos(String searchTerm,
      {String nextPageToken = ""}) async {
    var resourceUri =
        "search?part=snippet&maxResults=10&type=video&key=${Constants.ApiKey}&q=${searchTerm}";

    if (nextPageToken.isNotEmpty) resourceUri += "&pageToken=${nextPageToken}";

    var response = await _httpClient.get(Uri.encodeFull(resourceUri),
        options: _cacheOptions);

    return VideoSearchResult.fromJson(response.data);
  }

  Future<ChannelSearchResult> getChannels(String channelIDs) async {
    var resourceUri =
        "channels?part=snippet,statistics&maxResults=10&id=${channelIDs}&key=${Constants.ApiKey}";

    var response = await _httpClient.get(Uri.encodeFull(resourceUri),
        options: _cacheOptions);

    return ChannelSearchResult.fromJson(response.data);
  }

  Future<YoutubeVideoDetail> getVideoDetails(String videoId) async {
    var resourceUri =
        "videos?part=contentDetails,id,snippet,statistics&key=${Constants.ApiKey}&id=${videoId}";

    var response = await _httpClient.get(Uri.encodeFull(resourceUri),
        options: _cacheOptions);

    return VideoDetailsResult.fromJson(response.data).items!.first;
  }
}
