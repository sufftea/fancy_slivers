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
    return SliverSomething(
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

class SliverSomething extends SingleChildRenderObjectWidget {
  const SliverSomething({
    required this.data,
    required this.fraction,
    super.child,
    super.key,
  });

  final ValueNotifier<SliverAnimatedPageData> data;
  final double fraction;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SliverSomethingRenderObject(
      data,
      fraction,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    SliverSomethingRenderObject renderObject,
  ) {
    renderObject.fraction = fraction;
  }
}

class SliverSomethingRenderObject extends RenderSliverSingleBoxAdapter {
  SliverSomethingRenderObject(
    this.data,
    this._fraction,
  );

  final ValueNotifier<SliverAnimatedPageData> data;

  double _fraction;
  double get fraction => _fraction;
  set fraction(double value) {
    if (_fraction == value) return;

    _fraction = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    geometry = SliverGeometry(
      scrollExtent: constraints.viewportMainAxisExtent * fraction,
      maxPaintExtent: constraints.viewportMainAxisExtent,
      layoutExtent: calculatePaintOffset(
        constraints,
        from: 0,
        to: constraints.viewportMainAxisExtent * fraction,
      ),
      paintExtent: min(
        min(
          constraints.remainingPaintExtent,
          constraints.viewportMainAxisExtent,
        ),
        constraints.viewportMainAxisExtent * (fraction - 1) +
            constraints.scrollOffset,
      ),
    );

    child!.layout(constraints.asBoxConstraints(
      maxExtent: constraints.viewportMainAxisExtent,
      minExtent: constraints.viewportMainAxisExtent,
    ));

    setChildParentData(child!, constraints, geometry!);

    /// ====== Calculate SliverAnimatedPageData ======

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePageData();
    });
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && geometry!.visible) {
      final paintOrigin = min(
        0.0,
        constraints.viewportMainAxisExtent * (fraction - 1) -
            constraints.scrollOffset,
      );

      context.paintChild(child!, offset + Offset(0, paintOrigin));
    }
  }

  void _updatePageData() {
    final p = constraints.scrollOffset -
        (constraints.viewportMainAxisExtent - constraints.remainingPaintExtent);

    data.value = SliverAnimatedPageData(
      progress: p / (constraints.viewportMainAxisExtent * (fraction - 1)),
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
