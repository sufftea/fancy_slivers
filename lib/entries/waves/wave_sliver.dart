import 'dart:math';
import 'dart:ui';

import 'package:fancy_slivers/main.dart';
import 'package:fancy_slivers/slivers/sliver_parallax/sliver_parallax.dart';
import 'package:fancy_slivers/utils/base_colors.dart';
import 'package:flutter/material.dart';

const _n = 5;

class WaveSliver extends StatefulWidget {
  const WaveSliver({
    required this.properties,
    super.key,
  });

  static final allWaves = [
    for (int i = 0; i <= _n; ++i)
      WaveProperties(
        parallaxSpeed: lerpDouble(0.3, 1, i / _n)!,
        position: lerpDouble(0.6, 0.3, i / _n)!,
        length: lerpDouble(20, 50, i / _n)!,
        amplitude: lerpDouble(5, 20, i / _n)!,
        angle: 0,
        // opacity: lerpDouble(0.2, 1, i / _n)!,
        opacity: pow((i + 1) / (_n + 1), 2).toDouble(),
        // offsetCoef: (sin(i * 10000) * 0.5 + 0.5) * 0.005,
        offsetCoef: 0.01 * pow(i / _n, 2),
      ),
    // const WaveProperties(
    //   parallaxSpeed: 1,
    //   position: 0.3,
    //   length: 50,
    //   amplitude: 30,
    //   angle: 0,
    //   opacity: 1,
    //   offsetCoef: 0.005,
    // ),
  ];

  final WaveProperties properties;

  @override
  State<WaveSliver> createState() => _WaveSliverState();
}

class _WaveSliverState extends State<WaveSliver> {
  late final FragmentShader shader;

  @override
  void initState() {
    super.initState();

    shader = ShaderProviders.wave.fragmentShader();
  }

  @override
  Widget build(BuildContext context) {
    return SliverParallax(
      speed: widget.properties.parallaxSpeed,
      viewportFraction: 1,
      dependencies: const {ParallaxAspect.contentOffset},
      computeLayoutExtent: (paintOffset) {
        return 0;
      },
      builder: (context, parallaxData) {
        return SizedBox(
          height: parallaxData.idealHeight,
          child: CustomPaint(
            // isComplex: true,
            willChange: true,
            painter: WavePainter(
              shader: shader,
              properties: widget.properties,
              offset: parallaxData.scrollOffset,
            ),
          ),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  WavePainter({
    required this.shader,
    required this.properties,
    required this.offset,
  });

  final FragmentShader shader;
  final WaveProperties properties;
  final double offset;

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return properties != oldDelegate.properties;
    // return shader != oldDelegate.shader;
  }

  @override
  void paint(Canvas canvas, Size size) {
    int i = 0;

    shader
          ..setFloat(i++, size.width)
          ..setFloat(i++, size.height)
          ..setFloat(i++, properties.position) // waweHeight
          ..setFloat(i++, properties.length) // wavelength
          ..setFloat(i++, properties.amplitude) // waveAmplitude
          ..setFloat(i++, properties.opacity) // opacity
          ..setFloat(i++, properties.angle) // angle
          ..setFloat(i++, offset * properties.offsetCoef) // offset
          ..setFloat(i++, BaseColors.wave.red / 255) // color
          ..setFloat(i++, BaseColors.wave.green / 255) // color
          ..setFloat(i++, BaseColors.wave.blue / 255) // color
        ;

    // canvas.drawRect(
    //   Offset.zero & size,
    //   Paint()..color = Color.fromARGB(255, 255, 0, 0).withOpacity(0.1),
    // );
    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = shader,
    );
  }
}

class WaveProperties {
  const WaveProperties({
    required this.parallaxSpeed,
    required this.position,
    required this.length,
    required this.amplitude,
    required this.opacity,
    required this.angle,
    required this.offsetCoef,
  });

  final double parallaxSpeed;
  final double position;
  final double length;
  final double amplitude;
  final double opacity;
  final double angle;
  final double offsetCoef;
}
