import 'dart:math';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SliverAnimatedPageData {
  const SliverAnimatedPageData({
    required this.progress,
    required this.maxHeight,
    required this.maxWidth,
    required this.scrollOffset,
  });

  const SliverAnimatedPageData._initial()
      : progress = -1,
        maxHeight = 0,
        maxWidth = 0,
        scrollOffset = 0;

  /// Convenience getter for [progress]
  double get preShowProgress => clampDouble(progress + 1, 0, 1);

  /// Convenience getter for [progress]
  double get showProgress => clampDouble(progress, 0, 1);

  /// Convenience getter for [progress]
  double get postShowProgress => clampDouble(progress - 1, 0, 1);

  /// Goes from -1 to 2.
  ///
  /// -1 -- 0: When the sliver has appeared from the bottom, but has not yet
  /// filled the view entirely.
  ///  0 -- 1: When the sliver has filled the view entirely
  ///  1 -- 2: When the sliver is moving out of the view (up)
  final double progress;
  final double maxHeight;
  final double maxWidth;
  final double scrollOffset;
}

typedef SliverAnimatedPageBuilder = Widget Function(
  BuildContext context,
  SliverAnimatedPageData data,
);

class SliverAnimatedPageStyle {
  const SliverAnimatedPageStyle({
    required this.timelineFraction,
    this.speed = 1,
    this.clip = true,
  });

  final double timelineFraction;
  final double speed;
  final bool clip;
}

class SliverAnimatedPage extends StatefulWidget {
  const SliverAnimatedPage({
    required this.builder,
    required this.style,
    super.key,
  });

  final SliverAnimatedPageBuilder builder;
  final SliverAnimatedPageStyle style;

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
      style: widget.style,
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
    required this.style,
    super.child,
    super.key,
  });

  final ValueNotifier<SliverAnimatedPageData> data;

  final SliverAnimatedPageStyle style;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SliverAnimatedPageRenderObject(
      data: data,
      style: style,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    SliverAnimatedPageRenderObject renderObject,
  ) {
    renderObject.style = style;
  }
}

class SliverAnimatedPageRenderObject extends RenderSliverSingleBoxAdapter {
  SliverAnimatedPageRenderObject({
    required SliverAnimatedPageStyle style,
    required this.data,
  }) : _style = style;

  final ValueNotifier<SliverAnimatedPageData> data;

  SliverAnimatedPageStyle _style;
  SliverAnimatedPageStyle get style => _style;
  set style(SliverAnimatedPageStyle value) {
    if (_style == value) return;

    _style = value;
    markNeedsLayout();
  }

  /// CONVENIENCE GETTERS
  double get oneLessHeight =>
      constraints.viewportMainAxisExtent * (style.timelineFraction - 1);

  @override
  void performLayout() {
    child!.layout(
      constraints.asBoxConstraints(
        maxExtent: constraints.viewportMainAxisExtent,
      ),
      parentUsesSize: true,
    );
    final childHeight = child!.size.height;

    geometry = SliverGeometry(
      scrollExtent: max(
        oneLessHeight + childHeight,
        0,
      ),
      maxPaintExtent: constraints.viewportMainAxisExtent,
      paintExtent: min(
        calculatePaintOffset(
          constraints,
          from: 0,
          to: oneLessHeight + childHeight,
        ),
        childHeight,
      ),
      visible: true,
    );

    setChildParentData(child!, constraints, geometry!);

    // ====== Calculate SliverAnimatedPageData ======
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePageData();
    });
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      // || !geometry!.visible
      return;
    }

    final o = max(
      constraints.scrollOffset - oneLessHeight,
      0.0,
    );

    if (style.clip) {
      context.clipRectAndPaint(
        offset & Size(constraints.crossAxisExtent, geometry!.paintExtent),
        Clip.hardEdge,
        Rect.zero,
        () {
          context.paintChild(child!, (offset - Offset(0, o)) * style.speed);
        },
      );
    } else {
      context.paintChild(child!, (offset - Offset(0, o)) * style.speed);
    }
  }

  void _updatePageData() {
    final p = constraints.scrollOffset -
        (constraints.viewportMainAxisExtent - constraints.remainingPaintExtent);

    data.value = SliverAnimatedPageData(
      progress: p / oneLessHeight,
      scrollOffset: constraints.scrollOffset,
      maxHeight: constraints.viewportMainAxisExtent,
      maxWidth: constraints.crossAxisExtent,
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
