import 'package:fancy_slivers/common/giant_name.dart';
import 'package:fancy_slivers/entries/page_2/appbar_2.dart';
import 'package:fancy_slivers/entries/page_2/picture_2.dart';
import 'package:fancy_slivers/entries/page_2/parallax_particles.dart';
import 'package:fancy_slivers/main.dart';
import 'package:fancy_slivers/slivers/sliver_stack.dart';
import 'package:fancy_slivers/utils/base_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class Page2Stack extends StatefulWidget {
  const Page2Stack({super.key});

  static const viewportFraction = 5.0;

  @override
  State<Page2Stack> createState() => _Page2StackState();
}

class _Page2StackState extends State<Page2Stack> {
  late final FragmentShader maskShader;

  @override
  void initState() {
    super.initState();

    maskShader = ShaderProviders.waveMask.fragmentShader();
  }

  @override
  Widget build(BuildContext context) {
    return SliverStack(
      children: [
        Container(color: BaseColors.wave),
        const GiantName(
          color: BaseColors.onWaveSaturated1,
          viewportFraction: Page2Stack.viewportFraction,
        ),
        const ParallaxParticles(
          speed: 0.2,
          asset: 'assets/svgs/arrow_particle_small.svg',
          verticalSpacing: 50,
          horizontalSpacing: 300,
          scale: 0.4,
        ),
        const ParallaxParticles(
          speed: 0.5,
          asset: 'assets/svgs/arrow_particle_small.svg',
          verticalSpacing: 100,
          horizontalSpacing: 350,
          scale: 0.6,
        ),
        const Picture2(),
        const Appbar2(),
        const ParallaxParticles(
          speed: 1.3,
          asset: 'assets/svgs/arrow_particle_big.svg',
          verticalSpacing: 400,
          horizontalSpacing: 500,
          scale: 1,
        ),
      ],
    );
  }
}
