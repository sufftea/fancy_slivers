import 'dart:ui' as ui;

import 'package:fancy_slivers/slivers/sliver_particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class ParticlesEntry extends StatelessWidget {
  const ParticlesEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverParticles(
      speed: 2,
      overlayBuilder: (context, data) {
        return ShaderBuilder(
          (context, shader, _) {
            return CustomPaint(
              painter: ShaderPainter(
                shader: shader,
                offset: data.scrollOffset * 2,
              ),
            );
          },
          assetKey: 'assets/shaders/particles.frag',
        );
      },
    );
  }
}

class ShaderPainter extends CustomPainter {
  const ShaderPainter({
    required this.shader,
    required this.offset,
  });

  final FragmentShader shader;
  final double offset;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, offset);

    ui.Image;

    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(ShaderPainter oldDelegate) {
    return offset != oldDelegate.offset || shader != oldDelegate.shader;
  }
}
