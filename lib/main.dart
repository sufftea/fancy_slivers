import 'package:fancy_slivers/entries/anim_page_1/anim_page_1.dart';
import 'package:fancy_slivers/entries/anim_page_2/anim_page_2.dart';
import 'package:fancy_slivers/entries/anim_page_3/anim_page_3.dart';
import 'package:fancy_slivers/entries/anim_page_4/anim_page_4.dart';
import 'package:fancy_slivers/paint_order_scroll_view/paint_order_scroll_view.dart';
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
        backgroundColor: Colors.white,
        body: PaintOrderScrollView(
          childrenPaintOrder: const [
            1,
            0,
            2,
            3,
            4,
          ],
          slivers: const [
            AnimPage1(),
            AnimPage2(),
            AnimPage3(),
            AnimPage4(),
            SliverToBoxAdapter(
              child: Placeholder(
                fallbackHeight: 400,
              ),
            ),
          ],
        ),
      ),
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
