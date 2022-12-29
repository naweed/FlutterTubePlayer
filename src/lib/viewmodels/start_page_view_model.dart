import 'package:tube_player/models/youtube_models.dart';
import 'package:tube_player/services/youtube_api_service.dart';
import 'package:tube_player/viewmodels/base_view_model.dart';

import '../app_constants.dart';

class StartPageViewModel extends BaseViewModel {
  final YoutubeApiService _apiService = YoutubeApiService();

  String _nextToken = "";
  String _searchTerm = "iPhone 14";

  List<YoutubeVideo> _youtubeVideos = [];
  List<YoutubeVideo> get YoutubeVideos => _youtubeVideos;

  StartPageViewModel() {
    Title = "TUBE PLAYER";
  }

  Future<void> searchVideos() async {
    setDataLoadingIndicators(isStarting: true);

    LoadingText = "Hold on while we search for Youtube videos...";

    _youtubeVideos = [];

    try {
      //Search for Youtube Videos
      await _getTubeVideos();

      DataLoaded = true;
    } catch (ex) {
      IsErrorState = true;
      ErrorMessage =
          "Something went wrong. Plz try again later and if the problem persists, plz contact support at ${Constants.EmailAddress}";
    } finally {
      setDataLoadingIndicators(isStarting: false);
    }
  }

  Future<void> _getTubeVideos() async {
    //Search the videos

    var videoSearchResult =
        await _apiService.searchVideos(_searchTerm, nextPageToken: _nextToken);

    var channelIDs = videoSearchResult.items!
        .map((video) => video.snippet!.channelId!)
        .join(",");

    var channelSearchResults = await _apiService.getChannels(channelIDs);

    videoSearchResult.items?.forEach((video) {
      video.snippet!.channelImageURL = channelSearchResults.items!
          .where((channel) => channel.id == video.snippet!.channelId!)
          .first
          .snippet!
          .thumbnails!
          .medium!
          .url!;
    });

    _nextToken = videoSearchResult.nextPageToken!;

    _youtubeVideos.addAll(videoSearchResult.items!);
  }

  Future<void> queryForVideos(String searchQuery) async {
    _nextToken = "";
    _searchTerm = searchQuery.trim();

    await searchVideos();
  }
}
