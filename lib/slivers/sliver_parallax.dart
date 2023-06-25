import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef ParallaxBuilder = Widget Function(
  BuildContext context,
  ParallaxData data,
);

class SliverParallax extends RenderObjectWidget {
  const SliverParallax({
    required this.speed,
    required this.builder,
    this.listen = false,
    this.sliverHeight,
    this.viewportFraction,
    super.key,
  }) : assert(sliverHeight != null || viewportFraction != null);

  /// 0 - 1 -- slower than the sliver
  final double speed;
  final double? sliverHeight;
  final double? viewportFraction;

  final ParallaxBuilder builder;
  final bool listen;

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
      listen: listen,
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
    required this.listen,
  });
  // TODO: get/set
  final double speed;
  final double? sliverHeight;
  final double? viewportFraction;
  final bool listen;

  void Function(ParallaxData)? _rebuildChildCallback;
  set rebuildChildCallback(void Function(ParallaxData)? fun) {
    _rebuildChildCallback = fun;
  }

  bool _childWasBuilt = false;

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

    if (!_childWasBuilt || listen) {
      _childWasBuilt = true;
      invokeLayoutCallback((_) {
        _rebuildChildCallback?.call(ParallaxData(
          idealHeight: idealHeight,
          sliverHeight: scrollExtent,
          scrollOffset: constraints.scrollOffset,
          contentOffset: (height) {
            return calculateChildOffset(scrollExtent, height);
          },
        ));
      });
    }

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

    final sliverCenter = constraints.precedingScrollExtent -
        constraints.scrollOffset +
        scrollExtent / 2;

    final childCenter =
        -(viewportCenter - sliverCenter) * speed + viewportCenter;

    return childCenter - childHeight / 2;
  }
}

class ParallaxData {
  ParallaxData({
    this.scrollOffset = 0,
    this.idealHeight = 0,
    this.sliverHeight = 0,
    this.contentOffset,
  });

  final double scrollOffset;
  final double idealHeight;
  final double sliverHeight;

  // content height is unknown when this is composed, so you need to provide 
  // the height you're going to set to the child.
  late final double Function(double contentHeight)? contentOffset;
}
