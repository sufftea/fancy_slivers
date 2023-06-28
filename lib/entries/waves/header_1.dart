// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui' as ui;

import 'package:fancy_slivers/slivers/sliver_parallax/sliver_parallax.dart';
import 'package:flutter/material.dart';

class Header1 extends StatelessWidget {
  const Header1({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverParallax(
      viewportFraction: 1,
      speed: 0,
      computeLayoutExtent: (paintOffset) {
        return 0;
      },
      builder: (context, data) {
        return SizedBox(
          height: data.idealHeight,
          child: Center(
            child: Text(
              'Hello,',
              style: TextStyle(
                fontSize: 100,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
