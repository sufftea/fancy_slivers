import 'dart:math';

import 'package:fancy_slivers/slivers/sliver_animated_page.dart';
import 'package:flutter/material.dart';

class AnimPage2 extends StatelessWidget {
  const AnimPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedPage(
      timelineFraction: 2,
      builder: (context, data) {
        return Container(
          height: max(data.maxHeight - 100, 0.0),
          color: Colors.amber,
          child: Placeholder(
            child: Center(
              child: Text(
                data.progress.toString(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
