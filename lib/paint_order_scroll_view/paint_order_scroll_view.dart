import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class PaintOrderScrollView extends CustomScrollView {
  const PaintOrderScrollView({
    required this.childrenPaintOrder,
    super.slivers,
    super.key,
  }) : assert(childrenPaintOrder.length == slivers.length);

  final List<int> childrenPaintOrder;

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset offset,
    AxisDirection axisDirection,
    List<Widget> slivers,
  ) {
    return PaintOrderViewport(
      childrenPaintOrder: childrenPaintOrder,
      axisDirection: axisDirection,
      offset: offset,
      slivers: slivers,
      cacheExtent: cacheExtent,
      center: center,
      anchor: anchor,
      clipBehavior: clipBehavior,
    );
  }
}

class PaintOrderViewport extends Viewport {
  PaintOrderViewport({
    super.key,
    super.axisDirection,
    super.crossAxisDirection,
    super.anchor = 0.0,
    required super.offset,
    super.center,
    super.cacheExtent,
    super.cacheExtentStyle,
    super.clipBehavior,
    super.slivers,
    required this.childrenPaintOrder,
  });

  final List<int> childrenPaintOrder;

  @override
  RenderViewport createRenderObject(BuildContext context) {
    return RenderPaintOrderViewport(
      axisDirection: axisDirection,
      crossAxisDirection: crossAxisDirection ??
          Viewport.getDefaultCrossAxisDirection(context, axisDirection),
      anchor: anchor,
      offset: offset,
      cacheExtent: cacheExtent,
      cacheExtentStyle: cacheExtentStyle,
      clipBehavior: clipBehavior,
      childrenPaintOrder: childrenPaintOrder,
    );
  }
}

class RenderPaintOrderViewport extends RenderViewport {
  RenderPaintOrderViewport({
    super.axisDirection,
    required super.crossAxisDirection,
    required super.offset,
    required this.childrenPaintOrder,
    super.anchor,
    super.children,
    super.center,
    super.cacheExtent,
    super.cacheExtentStyle,
    super.clipBehavior,
  });

  /// TODO: getter and setter
  final List<int> childrenPaintOrder;

  @override
  Iterable<RenderSliver> get childrenInPaintOrder {
    final List<RenderSliver> children = <RenderSliver>[];

    RenderSliver? child = firstChild;
    while (child != null) {
      children.add(child);
      child = childAfter(child);
    }

    final childrenReordered = <RenderSliver>[];
    for (final childIndex in childrenPaintOrder) {
      childrenReordered.add(children[childIndex]);
    }

    return childrenReordered;
  }

  // TODO: override hittest too
}
