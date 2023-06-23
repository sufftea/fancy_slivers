import 'dart:math';

import 'package:fancy_slivers/slivers/sliver_parallax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class AnimPage1 extends StatelessWidget {
  const AnimPage1({
    required this.image,
    required this.speed,
    super.key,
  });

  final String image;
  final double speed;

  @override
  Widget build(BuildContext context) {
    return SliverParallax(
      speed: 1.5,
      viewportFraction: 1.5,
      // autoSize: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints is! MyCustomConstraints) {
            throw TypeError();
          }

          // final height = constraints.sliverHeight;

          return Placeholder(
            fallbackHeight: constraints.idealHeight,
            color: Colors.blue,
            strokeWidth: 4,
          );

          return SizedBox(
            // height: height,
            child: ShaderBuilder(
              (context, shader, child) {
                return CustomPaint(
                  painter: WavePainter(shader: shader),
                );
              },
              assetKey: 'assets/shaders/wave.frag',
            ),
          );
        },
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  WavePainter({
    required this.shader,
  });

  final FragmentShader shader;

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return shader != oldDelegate.shader;
  }

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, 0.3) // waweHeight
      ..setFloat(3, 0) // time
      ..setFloat(4, 0.3) // color
      ..setFloat(5, 0.75) // color
      ..setFloat(6, 0.9); // color

    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = shader,
    );
  }
}
