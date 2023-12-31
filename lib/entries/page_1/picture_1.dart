import 'package:fancy_slivers/slivers/sliver_parallax/sliver_parallax.dart';
import 'package:fancy_slivers/utils/landscape_content_wrapper.dart';
import 'package:flutter/material.dart';

class Picture1 extends StatelessWidget {
  const Picture1({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverParallax(
      viewportFraction: 1.5,
      speed: 0,
      computeLayoutExtent: (paintOffset) {
        return 0;
      },
      builder: (context, data) {
        return LandscapeContentWrapper(
          height: data.idealHeight,
          child: Stack(
            children: [
              Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: buildContent(data),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildContent(ParallaxData data) {
    final height = data.sliverConstraints.viewportMainAxisExtent - 140;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: height,
        width: 400,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          'assets/images/hotel_outside.jpeg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
