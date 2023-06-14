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

class _SliverAnimatedPageState extends State<SliverAnimatedPage>
    with TickerProviderStateMixin {
  final data = ValueNotifier<SliverAnimatedPageData>(
      const SliverAnimatedPageData._initial());

  @override
  Widget build(BuildContext context) {
    RenderAnimatedSize;
    return SliverSomething(
      vsync: this,
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
    required this.vsync,
    required this.data,
    required this.fraction,
    super.child,
    super.key,
  });

  final ValueNotifier<SliverAnimatedPageData> data;
  final double fraction;
  final TickerProvider vsync;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SliverSomethingRenderObject(
      vsync: vsync,
      data: data,
      fraction: fraction,
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
  SliverSomethingRenderObject({
    required TickerProvider vsync,
    required double fraction,
    required this.data,
  })  : _fraction = fraction,
        animController = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 400),
        ) {
    animController.addListener(() {
      // debugPrint("animanin'. value: ${animController.value}");
      markNeedsLayout();
    });
  }

  final ValueNotifier<SliverAnimatedPageData> data;
  final AnimationController animController;

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
  double get animValue => switch (animController.status) {
        AnimationStatus.forward ||
        AnimationStatus.dismissed =>
          CurveTween(curve: Curves.easeOutCirc).evaluate(
            animController,
          ),
        AnimationStatus.reverse ||
        AnimationStatus.completed =>
          CurveTween(curve: Curves.easeInCirc).evaluate(
            animController,
          ),
      };

  double get animatedHeightReduction => max(
        constraints.viewportMainAxisExtent * animValue - 300,
        0,
      );

  @override
  void performLayout() {
    final realLayoutExtent = calculatePaintOffset(
      constraints,
      from: 0,
      to: realHeight,
    );

    geometry = SliverGeometry(
      scrollExtent: realHeight - animatedHeightReduction,
      maxPaintExtent: constraints.viewportMainAxisExtent,
      paintExtent: max(
        realLayoutExtent - animatedHeightReduction,
        0,
      ),
    );

    child!.layout(constraints.asBoxConstraints(
      maxExtent: constraints.viewportMainAxisExtent,
      minExtent: constraints.viewportMainAxisExtent,
    ));

    setChildParentData(child!, constraints, geometry!);

    // ====== Animation ======

    switch (animController.status) {
      case AnimationStatus.reverse || AnimationStatus.dismissed:
        if (realLayoutExtent < constraints.viewportMainAxisExtent &&
            constraints.scrollOffset > 0) {
          animController.forward();
        }
      case AnimationStatus.forward || AnimationStatus.completed:
        if (realLayoutExtent >= constraints.viewportMainAxisExtent ||
            constraints.scrollOffset == 0) {
          animController.reverse();
        }
      default:
    }

    // ====== Calculate SliverAnimatedPageData ======

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePageData();
    });
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && geometry!.visible) {
      final paintOrigin = min(
        0.0,
        oneLessHeight - constraints.scrollOffset - animatedHeightReduction,
      );

      context.paintChild(child!, offset + Offset(0, paintOrigin));
    }
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
