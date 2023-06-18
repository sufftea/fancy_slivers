import 'dart:math';

import 'package:fancy_slivers/slivers/sliver_animated_page.dart';
import 'package:flutter/material.dart';

class AnimPage2 extends StatelessWidget {
  const AnimPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedPage(
      style: const SliverAnimatedPageStyle(
        timelineFraction: 2,
        clip: false,
        speed: 0.5,
      ),
      builder: (context, data) {
        return Container(
          height: max(
            data.maxHeight - 100 * data.showProgress,
            0.0,
          ),
          color: Colors.transparent,
          child: const Placeholder(),
        );
      },
    );
  }
}
