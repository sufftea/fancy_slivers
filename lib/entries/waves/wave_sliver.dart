import 'dart:ui';

import 'package:fancy_slivers/slivers/sliver_parallax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const _n = 4;

class WaveSliver extends StatelessWidget {
  const WaveSliver({
    required this.properties,
    super.key,
  });

  static final allWaves = [
    for (int i = 0; i <= _n; ++i)
      WaveProperties(
        parallaxSpeed: lerpDouble(0.1, 1.5, i / _n)!,
        position: lerpDouble(0.7, 0.4, i / _n)!,
        length: lerpDouble(20, 50, i / _n)!,
        amplitude: lerpDouble(10, 40, i / _n)!,
        quirk: i / _n + 20,
        flickers: lerpDouble(10, 50, i / _n)!,
      ),
    const WaveProperties(
      parallaxSpeed: 2,
      position: 0.4,
      length: 50,
      amplitude: 40,
      quirk: 1,
      flickers: 100000,
    ),
  ];

  final WaveProperties properties;

  @override
  Widget build(BuildContext context) {
    return SliverParallax(
      speed: properties.parallaxSpeed,
      viewportFraction: 1,
      builder: (context, parallaxData) {
        debugPrint('building child. received value: $parallaxData');

        return SizedBox(
          height: parallaxData.idealHeight,
          child: ShaderBuilder(
            (context, shader, child) {
              return RepaintBoundary.wrap(
                CustomPaint(
                  isComplex: true,
                  painter: WavePainter(
                    shader: shader,
                    properties: properties,
                  ),
                ),
                1,
              );
            },
            assetKey: 'assets/shaders/wave.frag',
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
  });

  final FragmentShader shader;
  final WaveProperties properties;

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return properties != oldDelegate.properties;
    // return shader != oldDelegate.shader;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // const color = Color.fromRGBO(57, 136, 255, 1);
    int i = 0;

    shader
          ..setFloat(i++, size.width)
          ..setFloat(i++, size.height)
          ..setFloat(i++, properties.position) // waweHeight
          ..setFloat(i++, properties.length) // wavelength
          ..setFloat(i++, properties.amplitude) // waveAmplitude
          ..setFloat(i++, properties.quirk) // quirk
          ..setFloat(i++, properties.flickers) // flickers
        ;

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
    required this.quirk,
    required this.flickers,
  });

  final double parallaxSpeed;
  final double position;
  final double length;
  final double amplitude;
  final double quirk;
  final double flickers;
}
