import 'dart:math';
import 'dart:ui';

import 'package:fancy_slivers/slivers/sliver_animated_page.dart';
import 'package:flutter/material.dart';

class AnimPage4 extends StatelessWidget {
  const AnimPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedPage(
      style: const SliverAnimatedPageStyle(
        timelineFraction: 4,
        speed: 1,
      ),
      builder: (context, data) {
        final topOffset = lerpDouble(
          0,
          data.maxWidth / 2,
          min(Curves.easeOutCirc.transform(data.showProgress) * 2, 1),
        )!;

        return Stack(
          children: [
            Positioned(
              top: -topOffset,
              right: 0,
              left: 0,
              height: data.maxHeight + topOffset,
              child: Container(
                color: Colors.blue.shade200,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(data.maxWidth / 2, 200),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
