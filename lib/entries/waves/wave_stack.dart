import 'package:fancy_slivers/entries/waves/header_1.dart';
import 'package:fancy_slivers/entries/waves/wave_sliver.dart';
import 'package:fancy_slivers/slivers/sliver_parallax.dart';
import 'package:fancy_slivers/slivers/sliver_stack.dart';
import 'package:fancy_slivers/utils/base_colors.dart';
import 'package:flutter/material.dart';

class WaveStack extends StatelessWidget {
  const WaveStack({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverStack(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            color: BaseColors.background,
          ),
        ),
        for (final wave in WaveSliver.allWaves)
          WaveSliver(
            properties: wave,
          ),
        SliverParallax(
          speed: 1,
          viewportFraction: 1,
          builder: (context, data) {

            debugPrint('idealHeight: ${data.idealHeight}');
            return SizedBox(
              height: data.idealHeight,
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    height: data.idealHeight * 0.15,
                    color: Colors.green,
                  ),
                ],
              ),
            );
          },
        ),
        const Header1(),
      ],
    );
  }
}
