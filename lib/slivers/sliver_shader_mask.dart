import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef SliverShaderCallback = Shader Function(
  SliverConstraints constraints,
  SliverGeometry geometry,
);

class SliverShaderMask extends SingleChildRenderObjectWidget {
  const SliverShaderMask({
    required this.createShader,
    required super.child,
    super.key,
  });

  final SliverShaderCallback createShader;

  @override
  SliverShaderMaskRenderObject createRenderObject(BuildContext context) {
    return SliverShaderMaskRenderObject(
      shaderCallback: createShader,
    );
  }
}

class SliverShaderMaskRenderObject extends RenderProxySliver {
  SliverShaderMaskRenderObject({required this.shaderCallback});

  final SliverShaderCallback shaderCallback;

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      layer ??= ShaderMaskLayer();

      layer!
        ..shader = shaderCallback(constraints, geometry!)
        ..maskRect =
            offset & Size(constraints.crossAxisExtent, geometry!.paintExtent)
        ..blendMode = BlendMode.modulate;

      context.pushLayer(layer!, super.paint, offset);

      assert(() {
        layer!.debugCreator = debugCreator;
        return true;
      }());
    } else {
      layer = null;
    }
  }
}
