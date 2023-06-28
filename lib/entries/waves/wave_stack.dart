import 'dart:ui' as ui;

import 'package:fancy_slivers/entries/waves/header_1.dart';
import 'package:fancy_slivers/entries/waves/wave_sliver.dart';
import 'package:fancy_slivers/main.dart';
import 'package:fancy_slivers/slivers/sliver_parallax/sliver_parallax.dart';
import 'package:fancy_slivers/slivers/sliver_shader_mask.dart';
import 'package:fancy_slivers/slivers/sliver_stack.dart';
import 'package:fancy_slivers/utils/base_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class WaveStack extends StatefulWidget {
  const WaveStack({super.key});

  @override
  State<WaveStack> createState() => _WaveStackState();
}

class _WaveStackState extends State<WaveStack> {
  late final FragmentShader maskShader;

  @override
  void initState() {
    super.initState();

    maskShader = ShaderProviders.waveMask.fragmentShader();
  }

  @override
  Widget build(BuildContext context) {
    return SliverShaderMask(
      createShader: (constraints, geometry) {
        debugPrint('offset: ${constraints.scrollOffset}');

        final p = WaveSliver.allWaves.last;
        int i = 0;
        maskShader
              ..setFloat(i++, constraints.crossAxisExtent) // width
              ..setFloat(i++, geometry.scrollExtent) // height
              ..setFloat(i++, -constraints.scrollOffset) // offset
              ..setFloat(i++, p.position) // waveHeight
              ..setFloat(i++, p.length) // waveLength
              ..setFloat(i++, p.amplitude) // amplitude
              ..setFloat(i++, p.angle) // angle
              ..setFloat(i++, constraints.scrollOffset * p.offsetCoef) // offset
              ..setFloat(i++, 1) // negative
            ;

        return maskShader;
      },
      child: SliverStack(
        children: [
          Container(color: BaseColors.background),
          for (int i = 0; i < WaveSliver.allWaves.length - 1; i++)
            WaveSliver(
              properties: WaveSliver.allWaves[i],
            ),
          const Header1(),
        ],
      ),
    );
  }
}
