import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CubePage3DRouter extends PageRouteBuilder {
  /// The duration of the transition
  final Duration duration;

  /// The next page we will show
  final Widget enterPage;

  /// The current page we will dismiss
  final Widget exitPage;

  /// Background color used when the transition is running , it's [Colors.black] as default
  final Color backgroundColor;

  CubePage3DRouter(
      {this.duration = const Duration(milliseconds: 350),
      required this.enterPage,
      required this.exitPage,
      this.backgroundColor = Colors.black})
      : super(pageBuilder: (context, animation, secondaryAnimation) {
          return ColoredBox(
            color: backgroundColor,
            child: Stack(
              children: [
                TranslateRotate(
                  tween: Tween(begin: Offset.zero, end: const Offset(-1, 0)),
                  alignment: FractionalOffset.centerRight,
                  animation: animation,
                  transformBuilder: (value) {
                    return Matrix4.identity()
                      ..setEntry(3, 2, 0.0012)
                      ..rotateY(pi / 2 * value);
                  },
                  child: exitPage,
                ),
                TranslateRotate(
                  tween: Tween(begin: const Offset(1, 0), end: Offset.zero),
                  alignment: FractionalOffset.centerLeft,
                  animation: animation,
                  transformBuilder: (value) {
                    return Matrix4.identity()
                      ..setEntry(3, 2, 0.0012)
                      ..rotateY(pi / 2 * (value - 1));
                  },
                  child: enterPage,
                ),
              ],
            ),
          );
        });
}

typedef TransformBuilder = Matrix4 Function(double animationValue);

class TranslateRotate extends StatelessWidget {
  final Animation animation;
  final Widget child;
  final TransformBuilder transformBuilder;
  final Alignment alignment;
  final Tween<Offset> tween;

  const TranslateRotate({
    Key? key,
    required this.animation,
    required this.transformBuilder,
    required this.alignment,
    required this.tween,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (BuildContext context, Widget? child) {
          return FractionalTranslation(
            translation: tween.transform(animation.value),
            child: Transform(
              transform: transformBuilder(animation.value),
              alignment: alignment,
              child: child,
            ),
          );
        });
  }
}
