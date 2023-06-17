import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SliverParticlesData {
  const SliverParticlesData({
    this.scrollOffset = 0,
    this.totalHeight = 0,
  });

  final double scrollOffset;
  final double totalHeight;
}

class SliverParticles extends StatelessWidget {
  SliverParticles({
    required this.speed,
    required this.overlayBuilder,
    super.key,
  });

  final double speed;
  final Widget Function(
    BuildContext context,
    SliverParticlesData data,
  ) overlayBuilder;

  final _data = ValueNotifier<SliverParticlesData>(const SliverParticlesData());

  @override
  Widget build(BuildContext context) {
    return SliverParticlesWidget(
      data: _data,
      child: ValueListenableBuilder(
        valueListenable: _data,
        builder: (context, value, child) {
          return overlayBuilder(context, value);
        },
      ),
    );
  }
}

// ======================================================================
// ======================================================================
// ======================================================================

class SliverParticlesWidget extends SingleChildRenderObjectWidget {
  const SliverParticlesWidget({
    required super.child,
    required ValueNotifier<SliverParticlesData> data,
    super.key,
  }) : _data = data;

  final ValueNotifier<SliverParticlesData> _data;

  @override
  RenderSliverSingleBoxAdapter createRenderObject(BuildContext context) {
    return SliverParticlesRenderObject(_data);
  }
}

class SliverParticlesRenderObject extends RenderSliverSingleBoxAdapter {
  SliverParticlesRenderObject(
    this._data,
  );

  final ValueNotifier<SliverParticlesData> _data;

  @override
  void performLayout() {
    child!.layout(constraints.asBoxConstraints(
      minExtent: constraints.viewportMainAxisExtent,
      maxExtent: constraints.viewportMainAxisExtent,
    ));

    geometry = SliverGeometry(
      layoutExtent: 0,
      paintExtent: constraints.viewportMainAxisExtent,
      maxPaintExtent: constraints.viewportMainAxisExtent,
      scrollExtent: 0,
    );

    final data = SliverParticlesData(
      scrollOffset: constraints.scrollOffset,
      totalHeight: constraints.viewportMainAxisExtent,
    );
    
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _data.value = data;
    });
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null || !geometry!.visible) {
      return;
    }

    context.paintChild(child!, Offset.zero);
  }
}
