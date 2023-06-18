import 'package:fancy_slivers/slivers/sliver_animated_page.dart';
import 'package:flutter/material.dart';

class AnimPage1 extends StatelessWidget {
  const AnimPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedPage(
      style: const SliverAnimatedPageStyle(
        timelineFraction: 1,
        speed: 0.5,
      ),
      builder: (context, data) {
        return Image.network(
          'https://www.availableideas.com/wp-content/uploads/2016/02/Sad-Puppy-Dog-Bokeh-Background-iPhone-6-wallpaper.jpg',
          fit: BoxFit.cover,
        );
      },
    );
  }
}
