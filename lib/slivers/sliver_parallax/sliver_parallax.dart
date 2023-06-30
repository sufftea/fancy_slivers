import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef ParallaxBuilder = Widget Function(
  BuildContext context,
  ParallaxData data,
);

typedef LayoutExtentCompter = double Function(double paintOffset);

class SliverParallax extends RenderObjectWidget {
  const SliverParallax({
    required this.speed,
    required this.builder,
    this.dependencies = const <ParallaxAspect>{ParallaxAspect.idealHeight},
    this.sliverHeight,
    this.viewportFraction,
    this.computeLayoutExtent,
    super.key,
  }) : assert(sliverHeight != null || viewportFraction != null);

  /// 0 - 1 -- slower than the sliver
  final double speed;
  final double? sliverHeight;
  final double? viewportFraction;
  final LayoutExtentCompter? computeLayoutExtent;

  final ParallaxBuilder builder;
  final Set<ParallaxAspect> dependencies;

  @override
  RenderObjectElement createElement() {
    return SliverParallaxElement(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SliverParallaxRenderObject(
      speed: speed,
      sliverHeight: sliverHeight,
      viewportFraction: viewportFraction,
      depedencies: dependencies,
      computeLayoutExtent: computeLayoutExtent,
    );
  }
}

class SliverParallaxElement extends RenderObjectElement {
  SliverParallaxElement(SliverParallax super.widget);

  Element? _child;

  @override
  SliverParallax get widget => super.widget as SliverParallax;
  @override
  SliverParallaxRenderObject get renderObject =>
      super.renderObject as SliverParallaxRenderObject;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_child != null) {
      visitor(_child!);
    }
  }

  @override
  void forgetChild(Element child) {
    assert(child == _child);
    _child = null;
    super.forgetChild(child);
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);

    renderObject.rebuildChildCallback = _updateCallback;
  }

  @override
  void update(SingleChildRenderObjectWidget newWidget) {
    super.update(newWidget);

    renderObject.rebuildChildCallback = _updateCallback;
    renderObject.markNeedsLayout();
  }

  @override
  void unmount() {
    renderObject.rebuildChildCallback = null;
    renderObject.child = null;
    super.unmount();
  }

  @override
  void insertRenderObjectChild(RenderObject child, Object? slot) {
    renderObject.child = child as RenderBox;
  }

  @override
  void moveRenderObjectChild(
    RenderObject child,
    Object? oldSlot,
    Object? newSlot,
  ) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(RenderObject child, Object? slot) {
    final renderObject = this.renderObject;

    renderObject.child = null;
    renderObject.rebuildChildCallback = null;
  }

  void _updateCallback(ParallaxData data) {
    owner!.buildScope(this, () {
      _child = updateChild(
        _child,
        widget.builder(this, data),
        null,
      );
    });
  }
}

class SliverParallaxRenderObject extends RenderSliverSingleBoxAdapter {
  SliverParallaxRenderObject({
    required this.speed,
    required this.sliverHeight,
    required this.viewportFraction,
    required this.depedencies,
    required this.computeLayoutExtent,
  });
  // TODO: get/set
  final double speed;
  final double? sliverHeight;
  final double? viewportFraction;
  final LayoutExtentCompter? computeLayoutExtent;
  final Set<ParallaxAspect> depedencies;

  void Function(ParallaxData)? _rebuildChildCallback;
  set rebuildChildCallback(void Function(ParallaxData)? fun) {
    _rebuildChildCallback = fun;
  }

  ParallaxData? _oldData;

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

    _rebuildChildIfNecessary(ParallaxData(
      idealHeight: idealHeight,
      sliverHeight: scrollExtent,
      scrollOffset: constraints.scrollOffset,
      sliverConstraints: constraints,
      speed: speed,
    ));

    child!.layout(
      constraints.asBoxConstraints(),
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
      layoutExtent: computeLayoutExtent?.call(paintOffset),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null || !geometry!.visible) {
      return;
    }

    final childOffset = calculateChildOffset(
      geometry!.scrollExtent,
      child!.size.height,
    );

    context.clipRectAndPaint(
      offset & Size(constraints.crossAxisExtent, geometry!.paintExtent),
      Clip.hardEdge,
      Rect.zero,
      () {
        context.paintChild(
          child!,
          Offset(
            offset.dx,
            childOffset,
          ),
        );
      },
    );
  }

  double calculateChildOffset(double scrollExtent, double childHeight) {
    final viewportCenter = constraints.viewportMainAxisExtent / 2;

    final sliverCenter = (constraints.viewportMainAxisExtent -
            constraints.remainingPaintExtent) -
        constraints.scrollOffset +
        scrollExtent / 2;

    // if (viewportFraction == 1.05)
    //   debugPrint(
    //       'sliverCenter: $sliverCenter; pse: ${constraints.precedingScrollExtent}; scrollOffset: ${constraints.scrollOffset}; ');

    final childCenter =
        -(viewportCenter - sliverCenter) * speed + viewportCenter;

    return childCenter - childHeight / 2;
  }

  void _rebuildChildIfNecessary(ParallaxData newData) {
    final old = _oldData;

    if (old == null) {
      invokeLayoutCallback((constraints) {
        _rebuildChildCallback?.call(newData);
      });

      _oldData = newData;

      return;
    }

    for (final dependency in depedencies) {
      final mustRebuild = switch (dependency) {
        ParallaxAspect.contentOffset => true,
        ParallaxAspect.idealHeight => old.idealHeight != newData.idealHeight,
        ParallaxAspect.scrollOffset => old.scrollOffset != newData.scrollOffset,
        ParallaxAspect.sliverHeight => old.sliverHeight != newData.sliverHeight,
      };

      if (mustRebuild) {
        invokeLayoutCallback((constraints) {
          _rebuildChildCallback?.call(newData);
        });

        _oldData = newData;

        return;
      }
    }
  }
}

class ParallaxData {
  ParallaxData({
    this.scrollOffset = 0,
    this.idealHeight = 0,
    this.sliverHeight = 0,
    required this.sliverConstraints,
    this.speed = 1,
  });

  final double scrollOffset;
  final double idealHeight;
  final double sliverHeight;

  final SliverConstraints sliverConstraints;
  final double speed;

  double contentOffset(
    double contentHeight, {
    double? withSpeed,
  }) {
    final constraints = sliverConstraints;

    // if (constraints == null) {
    //   return 0;
    // }

    final viewportCenter = constraints.viewportMainAxisExtent / 2;

    final sliverCenter = constraints.precedingScrollExtent -
        constraints.scrollOffset +
        sliverHeight / 2;

    final speed = withSpeed ?? this.speed;
    final childCenter =
        -(viewportCenter - sliverCenter) * speed + viewportCenter;

    return childCenter - contentHeight / 2;
  }
}

enum ParallaxAspect {
  scrollOffset,
  idealHeight,
  sliverHeight,
  contentOffset,
}
