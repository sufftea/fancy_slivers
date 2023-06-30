import 'package:fancy_slivers/slivers/sliver_parallax/sliver_parallax.dart';
import 'package:fancy_slivers/utils/base_colors.dart';
import 'package:fancy_slivers/utils/landscape_content_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GiantName extends StatelessWidget {
  const GiantName({
    required this.color,
    required this.viewportFraction,
    super.key,
  });

  final Color color;
  final double viewportFraction;

  @override
  Widget build(BuildContext context) {
    return SliverParallax(
      speed: 0,
      viewportFraction: viewportFraction,
      computeLayoutExtent: (paintOffset) {
        return 0;
      },
      builder: (context, data) {
        return LandscapeContentWrapper(
          height: data.idealHeight,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                height: data.sliverConstraints.viewportMainAxisExtent,
                child: buildContent(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Text(
              'Welcome to...',
              style: GoogleFonts.robotoSlab(
                fontSize: 50,
                fontWeight: FontWeight.w200,
                color: color,
                letterSpacing: 2.5,
              ),
            ),
            Text(
              'Oueiue',
              style: GoogleFonts.robotoSlab(
                fontSize: 200,
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: -10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
