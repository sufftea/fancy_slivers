import 'package:fancy_slivers/entries/waves/header_1.dart';
import 'package:fancy_slivers/entries/waves/wave_sliver.dart';
import 'package:fancy_slivers/slivers/sliver_stack.dart';
import 'package:flutter/material.dart';

class WaveStack extends StatelessWidget {
  const WaveStack({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverStack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
          ),
        ),
        for (final wave in WaveSliver.allWaves)
          WaveSliver(
            properties: wave,
          ),
          const Header1(),
      ],
    );
  }
}
