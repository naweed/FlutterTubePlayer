import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tube_player/app_styles.dart';

class LoadingIndicator extends StatelessWidget {
  final String LoadingText;

  const LoadingIndicator({required this.LoadingText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36),
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitCubeGrid(
            color: kLightColor,
            size: 32,
          ),
          SizedBox(height: 32),
          Text(
            LoadingText,
            style: kRegularLightText16,
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }
}
