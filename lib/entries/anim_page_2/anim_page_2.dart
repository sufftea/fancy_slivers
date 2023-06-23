import 'dart:math';

import 'package:fancy_slivers/slivers/sliver_animated_page.dart';
import 'package:flutter/material.dart';

class AnimPage2 extends StatelessWidget {
  const AnimPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedPage(
      style: SliverAnimatedPageStyle(
        timelineFraction: 2,
        clip: false,
        speed: 0.5,
        visible: (constraints) {
          return constraints.scrollOffset <
              constraints.viewportMainAxisExtent * 2;
        },
      ),
      builder: (context, data) {
        return SizedBox(
          height: max(
            data.viewportHeight - 100 * data.showProgress,
            0.0,
          ),
          child: const Placeholder(),
        );
      },
    );
  }
}
