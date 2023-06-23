import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SliverParallax extends SingleChildRenderObjectWidget {
  const SliverParallax({
    required super.child,
    required this.speed,
    this.sliverHeight,
    this.viewportFraction,
    super.key,
  }) : assert(sliverHeight != null || viewportFraction != null);

  /// 0 - 1 -- slower than the sliver
  final double speed;
  final double? sliverHeight;
  final double? viewportFraction;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SliverParallaxRenderObject(
      speed: speed,
      sliverHeight: sliverHeight,
      viewportFraction: viewportFraction,
    );
  }
}

class SliverParallaxRenderObject extends RenderSliverSingleBoxAdapter {
  SliverParallaxRenderObject({
    required this.speed,
    required this.sliverHeight,
    required this.viewportFraction,
  });
  final double speed;
  final double? sliverHeight;
  final double? viewportFraction;

  @override
  void performLayout() {
    final scrollExtent =
        sliverHeight ?? constraints.viewportMainAxisExtent * viewportFraction!;

    final idealHeight = switch (speed) {
      <= 1 => () {
          final a = scrollExtent / 2;
          final b = constraints.viewportMainAxisExtent / 2;
          return (a + (b - a) * (1 - speed)) * 2;
        }(),
      _ => () {
          final a = scrollExtent / 2;
          final b = constraints.viewportMainAxisExtent / 2;
          return (a + (b + a) * (speed - 1)) * 2;
        }(),
    };

    debugPrint('idealHeight: $idealHeight');

    child!.layout(
      MyCustomConstraints(
        width: constraints.crossAxisExtent,
        sliverHeight: scrollExtent,
        idealHeight: idealHeight,
      ),
      parentUsesSize: true,
    );

    final paintOffset = calculatePaintOffset(
      constraints,
      from: 0.0,
      to: scrollExtent,
    );

    geometry = SliverGeometry(
      scrollExtent: scrollExtent,
      paintExtent: paintOffset,
      maxPaintExtent: scrollExtent,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null || !geometry!.visible) {
      return;
    }

    final viewportCenter = constraints.viewportMainAxisExtent / 2;

    final sliverCenter =
        offset.dy - constraints.scrollOffset + geometry!.scrollExtent / 2;

    final childCenter =
        -(viewportCenter - sliverCenter) * speed + viewportCenter;

    final childDy = childCenter - child!.size.height / 2;

    context.clipRectAndPaint(
      offset & Size(constraints.crossAxisExtent, geometry!.paintExtent),
      Clip.hardEdge,
      Rect.zero,
      () {
        context.paintChild(child!, Offset(offset.dx, childDy));
      },
    );
  }
}

class MyCustomConstraints extends BoxConstraints {
  const MyCustomConstraints({
    required double width,
    double minHeight = 0.0,
    double maxHeight = double.infinity,
    this.sliverHeight = 0,
    this.idealHeight = 0,
  }) : super(
          minWidth: width,
          maxWidth: width,
          minHeight: minHeight,
          maxHeight: maxHeight,
        );

  final double sliverHeight;
  final double idealHeight;
}
