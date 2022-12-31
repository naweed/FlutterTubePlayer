// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables

import 'package:avatar_view/avatar_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tube_player/app_styles.dart';
import 'package:tube_player/viewmodels/start_page_view_model.dart';
import 'package:tube_player/views/video_details_page.dart';
import '../models/youtube_models.dart';
import '../viewcontrols/error_indicator.dart';
import '../viewcontrols/loading_indicator.dart';

class StartPage extends StatelessWidget {
  late StartPageViewModel viewModel;
  final _searchBarController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartPageViewModel>.reactive(
      viewModelBuilder: () => StartPageViewModel(),
      onModelReady: (vm) {
        _scrollController.addListener(() {
          if (_scrollController.position.pixels >
              (0.95 * _scrollController.position.maxScrollExtent))
            vm.loadMoreVideos();
        });

        vm.searchVideos();
      },
      builder: (context, vm, child) {
        viewModel = vm;

        return Scaffold(
          backgroundColor: kPageBackgroundColor,
          appBar: AppBar(
            leading: Icon(Icons.menu),
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
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: Column(
          children: [
            // Search Bar
            _buildSearchBar(),
            //Spacing
            SizedBox(
              height: 8,
            ),
            //ListView (of all the youtube videos)
            Expanded(
              child: _buildVideoList(),
            ),
            SizedBox(height: 8),
            Visibility(
              visible: viewModel.isLoadingMore,
              child: Center(
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kLightColor)),
                ),
              ),
            ),
          ],
        ),
      );

    return Container();
  }

  Widget _buildVideoList() {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        return _buildVideoCell(context, viewModel.YoutubeVideos[index]);
      },
      itemCount: viewModel.YoutubeVideos.length,
    );
  }

  Widget _buildVideoCell(BuildContext context, YoutubeVideo video) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => VideoDetailsPage(videoId: video.id!.videoId!))),
        child: Card(
          color: kCardFillColor,
          elevation: 8,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 9 / 5,
                  child: CachedNetworkImage(
                    imageUrl: video.snippet!.thumbnails!.high!.url!,
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kLightColor),
                          )),
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            )
                          ],
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    AvatarView(
                      radius: 18,
                      borderWidth: 1,
                      borderColor: kLightBorderColor,
                      avatarType: AvatarType.CIRCLE,
                      backgroundColor: Colors.transparent,
                      imagePath: video.snippet!.channelImageURL!,
                      placeHolder: Container(),
                      errorWidget: Container(),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.snippet!.channelTitle!,
                            style: kMediumLightText18,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            video.snippet!.title!,
                            style: kRegularLightText14,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: kLightBorderColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        padding: EdgeInsets.all(10),
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kDarkColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: _searchBarController,
          onSubmitted: (value) =>
              viewModel.queryForVideos(_searchBarController.text),
          style: kRegularLightText16,
          decoration: InputDecoration(
            filled: true,
            hintText: "Search videos...",
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 6),
            hintStyle: kRegularLightText16.copyWith(
                color: kLightTextColor.withOpacity(0.5)),
            border: InputBorder.none,
            fillColor: Colors.transparent,
            prefixIcon: Padding(
              padding: EdgeInsets.only(right: 8, left: 8),
              child: InkWell(
                onTap: () =>
                    viewModel.queryForVideos(_searchBarController.text),
                child: Icon(
                  Icons.search,
                  color: kLightColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
