import 'dart:math';

import 'package:fancy_slivers/entries/waves/wave_sliver.dart';
import 'package:fancy_slivers/slivers/sliver_parallax.dart';
import 'package:flutter/material.dart';

class Header1 extends StatelessWidget {
  const Header1({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverParallax(
      viewportFraction: 1,
      speed: WaveSliver.allWaves.last.parallaxSpeed,
      listen: true,
      builder: (context, data) {

        final topOffset = data.contentOffset?.call(data.idealHeight) ?? 0;

        debugPrint('topOffset = $topOffset');

        return SizedBox(
          height: data.idealHeight,
          child: Stack(
            children: [
              Positioned(
                top: - topOffset,
                right: 0,
                left: 0,
                bottom: 0,
                child: const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Header',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 100,
                      fontWeight: FontWeight.bold
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
