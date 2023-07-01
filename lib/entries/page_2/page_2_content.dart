import 'package:fancy_slivers/entries/page_2/page_2_stack.dart';
import 'package:fancy_slivers/slivers/sliver_parallax/sliver_parallax.dart';
import 'package:fancy_slivers/utils/landscape_content_wrapper.dart';
import 'package:flutter/material.dart';

class Picture2 extends StatelessWidget {
  const Picture2({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverParallax(
      viewportFraction: Page2Stack.viewportFraction,
      speed: 0,
      builder: (context, data) {
        return LandscapeContentWrapper(
          height: data.idealHeight,
          child: Stack(
            children: [
              Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: buildImage(data),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildImage(ParallaxData data) {
    final height = data.sliverConstraints.viewportMainAxisExtent - 140;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: height,
        width: 400,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          'assets/images/underwater_bedroom.jpeg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}