import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SliverAnimatedPageData {
  const SliverAnimatedPageData({
    required this.progress,
  });

  const SliverAnimatedPageData._initial() : progress = -1;

  /// Goes from -1 to 2.
  ///
  /// -1 -- 0: When the sliver has appeared from the bottom, but has not yet
  /// filled the view entirely.
  ///  0 -- 1: When the sliver has filled the view entirely
  ///  1 -- 2: When the sliver is moving out of the view (up)
  final double progress;
}

typedef SliverAnimatedPageBuilder = Widget Function(
  BuildContext context,
  SliverAnimatedPageData data,
);

class SliverAnimatedPage extends StatefulWidget {
  const SliverAnimatedPage({
    required this.builder,
    required this.timelineFraction,
    super.key,
  });

  final SliverAnimatedPageBuilder builder;
  final double timelineFraction;

  @override
  State<SliverAnimatedPage> createState() => _SliverAnimatedPageState();
}

class _SliverAnimatedPageState extends State<SliverAnimatedPage> {
  final data = ValueNotifier<SliverAnimatedPageData>(
      const SliverAnimatedPageData._initial());

  @override
  Widget build(BuildContext context) {
    RenderAnimatedSize;
    return SliverAnimatedPageWidget(
      data: data,
      fraction: widget.timelineFraction,
      child: ValueListenableBuilder(
        valueListenable: data,
        builder: (context, value, child) {
          return widget.builder(context, value);
        },
      ),
    );
  }
}

class SliverAnimatedPageWidget extends SingleChildRenderObjectWidget {
  const SliverAnimatedPageWidget({
    required this.data,
    required this.fraction,
    super.child,
    super.key,
  });

  final ValueNotifier<SliverAnimatedPageData> data;
  final double fraction;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SliverAnimatedPageRenderObject(
      data: data,
      fraction: fraction,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    SliverAnimatedPageRenderObject renderObject,
  ) {
    renderObject.fraction = fraction;
  }
}

class SliverAnimatedPageRenderObject extends RenderSliverSingleBoxAdapter {
  SliverAnimatedPageRenderObject({
    required double fraction,
    required this.data,
  }) : _fraction = fraction;

  final ValueNotifier<SliverAnimatedPageData> data;

  double _fraction;
  double get fraction => _fraction;
  set fraction(double value) {
    if (_fraction == value) return;

    _fraction = value;
    markNeedsLayout();
  }

  /// CONVENIENCE GETTERS
  double get realHeight => constraints.viewportMainAxisExtent * fraction;
  double get oneLessHeight =>
      constraints.viewportMainAxisExtent * (fraction - 1);

  @override
  void performLayout() {
    geometry = SliverGeometry(
      scrollExtent: max(
        realHeight,
        0,
      ),
      maxPaintExtent: constraints.viewportMainAxisExtent,
      paintExtent: calculatePaintOffset(
        constraints,
        from: 0,
        to: realHeight,
      ),
    );

    child!.layout(constraints.asBoxConstraints(
      maxExtent: constraints.viewportMainAxisExtent,
      minExtent: constraints.viewportMainAxisExtent,
    ));

    setChildParentData(child!, constraints, geometry!);

    // ====== Calculate SliverAnimatedPageData ======

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePageData();
    });
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null || !geometry!.visible) {
      return;
    }

    context.clipRectAndPaint(
      offset &
          Size(
            constraints.crossAxisExtent,
            geometry!.paintExtent,
          ),
      Clip.hardEdge,
      Rect.zero,
      () {
        context.paintChild(child!, Offset.zero);
      },
    );
  }

  void _updatePageData() {
    final p = constraints.scrollOffset -
        (constraints.viewportMainAxisExtent - constraints.remainingPaintExtent);

    data.value = SliverAnimatedPageData(
      progress: p / oneLessHeight,
    );
  }
}

/*

constraints - in
geometry - out

--

paintExtent, layoutExtent


---- playground code ------------------------------------------


    const preferedHeight = 500.0;

    child!.layout(constraints.asBoxConstraints(
      maxExtent: preferedHeight,
      minExtent: preferedHeight,
    ));

    final paintOffset = calculatePaintOffset(
      constraints,
      from: 0.0,
      to: preferedHeight,
    );

    geometry = SliverGeometry(
      maxPaintExtent: preferedHeight,
      paintExtent: paintOffset,
      scrollExtent: preferedHeight,
    );

    setChildParentData(child!, constraints, geometry!);


-----------------------------------------------------------------
*/
