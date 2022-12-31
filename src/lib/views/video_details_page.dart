// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tube_player/viewmodels/video_details_page_view_model.dart';

import '../app_styles.dart';
import '../viewcontrols/error_indicator.dart';
import '../viewcontrols/loading_indicator.dart';

class VideoDetailsPage extends StatelessWidget {
  final String videoId;
  late VideoDetailsPageViewModel viewModel;

  VideoDetailsPage({required this.videoId});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VideoDetailsPageViewModel>.reactive(
      viewModelBuilder: () => VideoDetailsPageViewModel(),
      onModelReady: (vm) {
        vm.getVideoDetails(videoId);
      },
      builder: (context, vm, child) {
        viewModel = vm;

        return Scaffold(
          backgroundColor: kPageBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,
            title: Text(
              vm.Title,
              style: kPageHeaderTextStyle,
            ),
          ),
          body: _buildUI(),
        );
      },
    );
  }

  Widget _buildUI() {
    // Check if there is any error and if so, show the error indicator
    if (viewModel.IsErrorState)
      return ErrorIndicator(ErrorText: viewModel.ErrorMessage);

    // Check the state is still busy, then show the loading indicator
    if (viewModel.IsBusy)
      return LoadingIndicator(LoadingText: viewModel.LoadingText);

    // If data is loaded, then show actual UI
    if (viewModel.DataLoaded)
      return Center(
        child: Text(viewModel.TheVideo.snippet!.title!),
      );

    return Container();
  }
}
