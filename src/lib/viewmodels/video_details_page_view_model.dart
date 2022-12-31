import 'package:tube_player/viewmodels/base_view_model.dart';

import '../app_constants.dart';
import '../models/youtube_models.dart';
import '../services/youtube_api_service.dart';

class VideoDetailsPageViewModel extends BaseViewModel {
  final YoutubeApiService _apiService = YoutubeApiService();

  late final YoutubeVideoDetail _theVideo;
  YoutubeVideoDetail get TheVideo => _theVideo;

  late final Channel _theChannel;
  Channel get TheChannel => _theChannel;

  VideoDetailsPageViewModel() {
    Title = "TUBE PLAYER";
  }

  Future<void> getVideoDetails(String videoId) async {
    setDataLoadingIndicators(isStarting: true);

    LoadingText = "Hold on while we load the video details...";

    try {
      //Load Video Details
      _theVideo = await _apiService.getVideoDetails(videoId);

      //Get Channel Image
      var channelSearchResults =
          await _apiService.getChannels(_theVideo.snippet!.channelId!);
      _theChannel = channelSearchResults.items!.first;

      DataLoaded = true;
    } catch (ex) {
      IsErrorState = true;
      ErrorMessage =
          "Something went wrong. Plz try again later and if the problem persists, plz contact support at ${Constants.EmailAddress}";
    } finally {
      setDataLoadingIndicators(isStarting: false);
    }
  }
}
