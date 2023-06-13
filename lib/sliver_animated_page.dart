import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SliverAnimatedPageData {}

typedef SliverAnimatedPageBuilder = Widget Function(
  BuildContext context,
  SliverAnimatedPageData? data,
);

class SliverAnimatedPage extends StatelessWidget {
  SliverAnimatedPage({
    required this.builder,
    super.key,
  });

  final SliverAnimatedPageBuilder builder;
  final _data = ValueNotifier<SliverAnimatedPageData?>(null);

  @override
  Widget build(BuildContext context) {
    return SliverSomething(
      data: _data,
      child: ValueListenableBuilder(
        valueListenable: _data,
        builder: (context, value, child) {
          return builder(context, value);
        },
      ),
    );
  }
}

class SliverSomething extends SingleChildRenderObjectWidget {
  const SliverSomething({
    required this.data,
    super.child,
    super.key,
  });

  final ValueNotifier<SliverAnimatedPageData?> data;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SliverSomethingRenderObject(data);
  }
}

class SliverSomethingRenderObject extends RenderSliverSingleBoxAdapter {
  SliverSomethingRenderObject(
    this.data,
  );

  final ValueNotifier<SliverAnimatedPageData?> data;

  @override
  void performLayout() {
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
  }
}


/*

constraints - in
geometry - out

--

paintExtent, layoutExtent

*/