import 'package:fancy_slivers/entries/page_2/page_2_stack.dart';
import 'package:fancy_slivers/slivers/sliver_parallax/sliver_parallax.dart';
import 'package:fancy_slivers/utils/base_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// const _verticalSpacing = 200.0;
// const _horizontalAmount = 4;

class ParallaxParticles extends StatelessWidget {
  const ParallaxParticles({
    required this.speed,
    required this.asset,
    required this.verticalSpacing,
    required this.horizontalSpacing,
    required this.scale,
    super.key,
  });

  final double speed;
  final String asset;
  final double verticalSpacing;
  final double horizontalSpacing;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return SliverParallax(
      speed: speed,
      viewportFraction: Page2Stack.viewportFraction,
      dependencies: const {ParallaxAspect.contentOffset},
      builder: (context, data) {
        return SizedBox(
          height: data.idealHeight,
          child: Stack(
            children: [
              for (int i = 0; i < data.idealHeight / verticalSpacing; i++)
                buildParticle(i, data),
            ],
          ),
        );
      },
    );
  }

  Widget buildParticle(int i, ParallaxData data) {
    double offset = data.sliverConstraints.viewportMainAxisExtent;
    if (speed > 1) {
      offset *= speed;
    }

    final horizontalAmount =
        data.sliverConstraints.crossAxisExtent / horizontalSpacing;

    return Positioned(
      top: verticalSpacing * i + offset,
      left: (i % horizontalAmount) * horizontalSpacing,
      child: Transform.scale(
        scale: scale,
        child: SvgPicture.asset(
          asset,
          colorFilter: const ColorFilter.mode(
            BaseColors.whiteSaturated,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
