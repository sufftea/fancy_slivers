// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:fancy_slivers/entries/page_2/page_2_stack.dart';
import 'package:fancy_slivers/slivers/sliver_parallax/sliver_parallax.dart';
import 'package:fancy_slivers/utils/base_colors.dart';
import 'package:fancy_slivers/utils/landscape_content_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Appbar2 extends StatelessWidget {
  const Appbar2({super.key});

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
                top: 5,
                left: 5,
                child: buildContent(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildContent() {
    TextStyle style(Color color) {
      return GoogleFonts.robotoSlab(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: color,
        decoration: TextDecoration.underline,
        letterSpacing: 1,
      );
    }

    return Row(
      children: [
        Text(
          'Hotel',
          style: style(BaseColors.black),
        ),
        const SizedBox(width: 30),
        Text(
          'Restaurant',
          style: style(BaseColors.onWaveSaturated2),
        ),
        const SizedBox(width: 30),
        Text(
          'Spa',
          style:  style(BaseColors.onWaveSaturated2),
        ),
        const SizedBox(width: 30),
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: BaseColors.onWave,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 30),
        Text(
          'Contact us',
          style:  style(BaseColors.black),
        ),
      ],
    );
  }
}
