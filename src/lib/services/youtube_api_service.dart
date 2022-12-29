import 'package:dio/dio.dart';
import 'package:tube_player/app_constants.dart';
import 'package:tube_player/models/youtube_models.dart';

class YoutubeApiService {
  late Dio _httpClient;

  YoutubeApiService() {
    _httpClient = Dio();
    _httpClient.options.baseUrl = Constants.ApiServiceURL;
  }

  Future<VideoSearchResult> searchVideos(String searchTerm,
      {String nextPageToken = ""}) async {
    var resourceUri =
        "search?part=snippet&maxResults=10&q=${searchTerm}&type=video&key=${Constants.ApiKey}";

    if (nextPageToken.isNotEmpty) resourceUri += "&pagetoken=${nextPageToken}";

    var response = await _httpClient.get(Uri.encodeFull(resourceUri));

    return VideoSearchResult.fromJson(response.data);
  }

  Future<ChannelSearchResult> getChannels(String channelIDs) async {
    var resourceUri =
        "channels?part=snippet,statistics&maxResults=10&id=${channelIDs}&key=${Constants.ApiKey}";

    var response = await _httpClient.get(Uri.encodeFull(resourceUri));

    return ChannelSearchResult.fromJson(response.data);
  }
}
