// import 'dart:ui';

// double listLerp(double value, List<double> points) {
//   assert(points.length > 2);

//   int index = ((points.length - 1) * value).floor();

//   return switch (value) {
//     >= 1 => points.last,
//     < 0 => points.first,
//     _ => lerpDouble(
//         points[index],
//         points[index + 1],
//         value * (points.length - 1),
//       )!,
//   };
// }
