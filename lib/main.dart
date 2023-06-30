import 'dart:ui' as ui;

import 'package:fancy_slivers/entries/page_1/page_1_stack.dart';
import 'package:fancy_slivers/entries/page_2/page_2_stack.dart';
import 'package:fancy_slivers/paint_order_scroll_view/paint_order_scroll_view.dart';
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
            const Page2Stack(),
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
