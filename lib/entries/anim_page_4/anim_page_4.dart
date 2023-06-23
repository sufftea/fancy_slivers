import 'dart:math';
import 'dart:ui';

import 'package:fancy_slivers/slivers/sliver_animated_page.dart';
import 'package:flutter/material.dart';

class AnimPage4 extends StatelessWidget {
  const AnimPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedPage(
      style: SliverAnimatedPageStyle(
        timelineFraction: 5,
        speed: 1,
        visible: (constraints) => null,
      ),
      builder: (context, data) {
        final topOffset = lerpDouble(
          0,
          200,
          min(Curves.easeOutCirc.transform(data.showProgress) * 2, 1),
        )!;

        return Stack(
          children: [
            Positioned(
              top: -topOffset,
              right: 0,
              left: 0,
              height: data.viewportHeight + topOffset,
              child: Container(
                color: Colors.blue.shade200,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(data.viewportWidth / 2, 200),
                    ),
                  ),
                  child: Stack(
                    children: [
                      buildContent(data),
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

  Widget buildContent(SliverAnimatedPageData data) {
    const up = 4;
    const sideway = 2;
    final sideOffset = lerpDouble(
      0,
      data.viewportWidth * (sideway - 1),
      data.showProgress,
    )!;
    final upOffset = lerpDouble(
      0,
      data.viewportHeight * (up - 1),
      data.showProgress,
    )!;

    return Positioned(
      top: 200 - upOffset,
      right: 0 - sideOffset,
      child: SizedBox(
        height: data.viewportHeight * up,
        width: data.viewportWidth * sideway,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildEntry1(data),
            buildEntry2(data),
            buildEntry3(data),
            buildEntry4(data),
          ],
        ),
      ),
    );
  }

  Widget buildEntry1(SliverAnimatedPageData data) {
    return Row(
      children: [
        const Spacer(),
        Container(
          color: Colors.amber,
          width: 300,
          height: 300,
        ),
        SizedBox(width: max(data.viewportWidth / 2 - 100, 0)),
      ],
    );
  }

  Widget buildEntry2(SliverAnimatedPageData data) {
    return Row(
      children: [
        const Spacer(),
        Container(
          color: Colors.amber,
          width: 300,
          height: 300,
        ),
        SizedBox(width: max(data.viewportWidth / 2 - 100, 0)),
      ],
    );
  }

  Widget buildEntry3(SliverAnimatedPageData data) {
    return Row(
      children: [
        const Spacer(),
        Container(
          color: Colors.amber,
          width: 300,
          height: 300,
        ),
        SizedBox(width: max(data.viewportWidth / 2 - 100, 0)),
      ],
    );
  }

  Widget buildEntry4(SliverAnimatedPageData data) {
    return Row(
      children: [
        const Spacer(),
        Container(
          color: Colors.amber,
          width: 300,
          height: 300,
        ),
        SizedBox(width: max(data.viewportWidth / 2 - 100, 0)),
      ],
    );
  }
}
