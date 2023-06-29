import 'package:fancy_slivers/entries/page_1/appbar_1.dart';
import 'package:fancy_slivers/entries/page_1/giant_name_1.dart';
import 'package:fancy_slivers/entries/page_1/picture_1.dart';
import 'package:fancy_slivers/entries/waves/wave_sliver.dart';
import 'package:fancy_slivers/main.dart';
import 'package:fancy_slivers/slivers/sliver_shader_mask.dart';
import 'package:fancy_slivers/slivers/sliver_stack.dart';
import 'package:fancy_slivers/utils/base_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class Page1Stack extends StatefulWidget {
  const Page1Stack({super.key});

  @override
  State<Page1Stack> createState() => _Page1StackState();
}

class _Page1StackState extends State<Page1Stack> {
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
          const GiantName1(),
          WaveSliver(
            properties: WaveSliver.allWaves[0],
          ),
          WaveSliver(
            properties: WaveSliver.allWaves[1],
          ),
          WaveSliver(
            properties: WaveSliver.allWaves[2],
          ),
          const Picture1(),
          WaveSliver(
            properties: WaveSliver.allWaves[3],
          ),
          WaveSliver(
            properties: WaveSliver.allWaves[4],
          ),
          const Appbar1(),
        ],
      ),
    );
  }
}
