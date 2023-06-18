import 'dart:math';
import 'dart:ui';

import 'package:fancy_slivers/slivers/sliver_animated_page.dart';
import 'package:flutter/material.dart';

class AnimPage3 extends StatelessWidget {
  const AnimPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedPage(
      style: const SliverAnimatedPageStyle(
        timelineFraction: 3,
        speed: 1,
        clip: false,
      ),
      builder: (context, data) {
        // final width = lerpDouble(200, data.maxWidth, data.preShowProgress) ?? 0;
        // double topOffset = clampDouble(data.scrollOffset, 0, width / 2);

        final width = lerpDouble(
          data.maxWidth / 2,
          data.maxWidth,
          min(
            Curves.easeInCirc.transform(data.preShowProgress) * 2,
            1,
          ),
        )!;
        final topOffset = lerpDouble(
          0,
          width / 2,
          min(Curves.easeOutCirc.transform(data.showProgress) * 2, 1),
        )!;

        return SizedBox(
          height: data.maxHeight -
              100 * Curves.easeInCirc.transform(data.showProgress),
          child: Stack(
            children: [
              Positioned(
                top: -topOffset,
                height: data.maxHeight + topOffset,
                width: width,
                left: (data.maxWidth - width) / 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(width / 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
