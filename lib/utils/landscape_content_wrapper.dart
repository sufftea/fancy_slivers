import 'package:flutter/material.dart';

class LandscapeContentWrapper extends StatelessWidget {
  const LandscapeContentWrapper({
    required this.child,
    required this.height,
    super.key,
  });

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 1080,
        child: child,
      ),
    );
  }
}
