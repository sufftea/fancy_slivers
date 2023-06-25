import 'package:fancy_slivers/entries/waves/wave_sliver.dart';
import 'package:fancy_slivers/entries/waves/header_1.dart';
import 'package:fancy_slivers/entries/waves/wave_stack.dart';
import 'package:fancy_slivers/paint_order_scroll_view/paint_order_scroll_view.dart';
import 'package:fancy_slivers/slivers/sliver_parallax.dart';
import 'package:fancy_slivers/slivers/sliver_stack.dart';
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
        backgroundColor: Colors.black,
        body: PaintOrderScrollView(
          childrenPaintOrder: const [
            0,
            1,
            2,
            3,
          ],
          slivers: [
            const WaveStack(),
            for (int i = 0; i < 3; i++)
              const SliverToBoxAdapter(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black),
                  child: Placeholder(
                    color: Colors.purple,
                    fallbackHeight: 500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
