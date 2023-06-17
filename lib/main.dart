import 'package:fancy_slivers/entries/anim_page_1/anim_page_1.dart';
import 'package:fancy_slivers/entries/anim_page_2/anim_page_2.dart';
import 'package:fancy_slivers/entries/particles_entry.dart';
import 'package:fancy_slivers/slivers/sliver_animated_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            const AnimPage1(),
            const AnimPage2(),
            buildAnimatedPage(Colors.blue),
            buildAnimatedPage(Colors.cyan),
            for (var i = 0; i < 3; ++i)
              const SliverToBoxAdapter(
                child: Placeholder(
                  fallbackHeight: 400,
                ),
              ),
          ],
        ),
      ),
    );
  }

  SliverAnimatedPage buildAnimatedPage(Color color) {
    return SliverAnimatedPage(
      timelineFraction: 2,
      builder: (context, data) {
        return Container(
          color: color,
          child: const Placeholder(),
        );
      },
    );
  }

  SliverLayoutBuilder buildScrollParalax() {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        const outerHeight = 500.0;
        const innerHeight = 700.0;
        // final innerHeight = constraints.viewportMainAxisExtent;

        final currPos = constraints.remainingPaintExtent +
            constraints.scrollOffset -
            outerHeight;
        final totalHeight = constraints.viewportMainAxisExtent - outerHeight;

        final progress = currPos / totalHeight;

        return SliverToBoxAdapter(
          child: SizedBox(
            height: outerHeight,
            child: Stack(
              children: [
                Positioned(
                  top: -(innerHeight - outerHeight) * (1 - progress),
                  left: 0,
                  right: 0,
                  height: innerHeight,
                  child: Image.network(
                    'https://wallpapercave.com/wp/wp4385795.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

