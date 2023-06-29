import 'dart:ui' as ui;

import 'package:fancy_slivers/entries/page_1/page_1_stack.dart';
import 'package:fancy_slivers/paint_order_scroll_view/paint_order_scroll_view.dart';
import 'package:fancy_slivers/slivers/sliver_parallax/sliver_parallax.dart';
import 'package:fancy_slivers/utils/base_colors.dart';
import 'package:flutter/material.dart';

class ShaderProviders {
  static late final ui.FragmentProgram waveMask;
  static late final ui.FragmentProgram wave;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ShaderProviders.waveMask =
      await ui.FragmentProgram.fromAsset('assets/shaders/wave_mask.frag');
  ShaderProviders.wave =
      await ui.FragmentProgram.fromAsset('assets/shaders/wave.frag');

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
            4,
            3,
            2,
            1,
            0,
          ],
          slivers: [
            const Page1Stack(),
            SliverParallax(
              speed: 0,
              viewportFraction: 1,
              builder: (context, data) {
                return Container(
                  height: data.idealHeight,
                  color: BaseColors.wave,
                  child: const Center(
                    child: Text(
                      'World',
                      style: TextStyle(
                        fontSize: 100,
                        color: BaseColors.onWave,
                      ),
                    ),
                  ),
                );
              },
            ),
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
