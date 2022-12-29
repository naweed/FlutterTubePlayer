import 'package:flutter/material.dart';

import '../app_styles.dart';

class ErrorIndicator extends StatelessWidget {
  final String ErrorText;

  const ErrorIndicator({required this.ErrorText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              child: Image.asset("assets/images/error.png"),
              height: 64,
              width: 64,
            ),
            SizedBox(height: 24),
            Text(
              "Uh-ho!",
              style: kMediumLightText18,
            ),
            SizedBox(height: 12),
            Text(
              ErrorText,
              style: kRegularLightText14,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
