import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef AniItemBuilder = Widget Function(
    BuildContext context, int index, double page, double aniValue);

class JunePageView extends StatefulWidget {
  final IndexedWidgetBuilder? itemBuilder;
  final AniItemBuilder? aniItemBuilder;
  final ValueChanged<int>? onPageChanged;
  final PageController? controller;
  final PageTransform? transform;
  final Modifier modifier;
  final int? cacheItemSize;
  final int? itemCount;

  const JunePageView({
    Key? key,
    required this.itemBuilder,
    this.modifier = const Modifier(),
    this.onPageChanged,
    this.controller,
    this.itemCount,
    this.cacheItemSize = 4,
    this.transform,
  })  : aniItemBuilder = null,
        super(key: key);

  const JunePageView.aniBuilder({
    Key? key,
    required this.aniItemBuilder,
    this.modifier = const Modifier(),
    this.controller,
    this.itemCount,
  })  : itemBuilder = null,
        onPageChanged = null,
        transform = null,
        cacheItemSize = 0,
        super(key: key);

  @override
  _JunePageViewState createState() => _JunePageViewState();
}

class _JunePageViewState extends State<JunePageView> {
  Map<int, Widget> cache = {};
  List<int> cacheIndexs = [];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = widget.controller ??
        PageController(
            initialPage: widget.modifier.initialPage,
            viewportFraction: widget.modifier.viewportFraction);
    widget.transform?.modifier = widget.modifier;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: widget.modifier.scrollDirection,
      controller: _pageController,
      padEnds: widget.modifier.padEnds,
      itemCount: widget.itemCount,
      physics: widget.modifier.physics,
      allowImplicitScrolling: widget.modifier.allowImplicitScrolling,
      clipBehavior: widget.modifier.clipBehavior,
      scrollBehavior: widget.modifier.scrollBehavior,
      dragStartBehavior: widget.modifier.dragStartBehavior,
      reverse: widget.modifier.reverse,
      itemBuilder: (BuildContext context, int index) {
        if (widget.aniItemBuilder != null) {
          return aniBuildItem(index, widget.aniItemBuilder);
        }
        return itemAniTransform(index, context);
      },
      onPageChanged: widget.onPageChanged,
    );
  }

  Widget aniBuildItem(int index, aniItemBuilder) {
    ///开始做动画
    return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double page = pageSafe(_pageController);
          final double aniValue = 1 - (page - index).abs();
          return aniItemBuilder(context, index, page, aniValue);
        });
  }

  Widget itemAniTransform(int index, BuildContext context) {
    Widget? item = cache[index];
    if (item == null) {
      item = widget.itemBuilder!(context, index);
      cache[index] = item;
      cacheIndexs.add(index);
      if (cacheIndexs.length > widget.cacheItemSize!) {
        cache.remove(cacheIndexs.removeAt(0));
      }
    }

    ///开始做动画
    return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double page = pageSafe(_pageController);
          final double changing = 1 - (page - index).abs();
          if(widget.transform == null) {
            return item!;
          }
          return widget.transform!.transform(index, page, changing, item!);
        });
  }

  double pageSafe(PageController pageController) {
    if (!pageController.position.hasContentDimensions || pageController.page == null) {
      return 0;
    } else {
      return pageController.page!;
    }
  }
}

abstract class PageTransform {
  Modifier? modifier;

  PageTransform();

  Widget transform(int index, double page, double aniValue, Widget child);
}

class Modifier {
  final PageController? controller;
  final double viewportFraction;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollPhysics? physics;
  final bool pageSnapping;
  final ValueChanged<int>? onPageChanged;
  final DragStartBehavior dragStartBehavior;
  final bool allowImplicitScrolling;
  final String? restorationId;
  final Clip clipBehavior;
  final ScrollBehavior? scrollBehavior;
  final bool padEnds;
  final int initialPage;

  const Modifier({
    this.scrollDirection = Axis.horizontal,
    this.initialPage = 0,
    this.reverse = false,
    this.viewportFraction = 1.0,
    this.controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.scrollBehavior,
    this.padEnds = true,
  });
}

class CubeTransform extends PageTransform {
  CubeTransform();

  @override
  Widget transform(int index, double page, double aniValue, Widget child) {
    if (aniValue < 0) {
      return const SizedBox();
    }
    if (modifier?.scrollDirection == Axis.horizontal) {
      return horizontal(aniValue, index, page, child);
    } else {
      return vertical(aniValue, index, page, child);
    }
  }

  Transform horizontal(double aniValue, int index, double page, Widget child) {
    var alignment = Alignment.centerRight;
    var value = 1 - aniValue;
    if (index > 0) {
      if (page >= index) {
        /// _pageController.page > index 向右滑动 划出下一页 下一页可见
        alignment = Alignment.centerRight;
        value = 1 - aniValue;
      } else {
        /// _pageController.page < index 向左滑动 划出上一页
        alignment = Alignment.centerLeft;
        value = aniValue - 1;
      }
    }
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(pi / 2 * value),
      alignment: alignment,
      child: child,
    );
  }

  Transform vertical(double aniValue, int index, double page, Widget child) {
    var alignment = Alignment.centerRight;
    var value = 1 - aniValue;
    if (index > 0) {
      if (page >= index) {
        /// _pageController.page > index 向上滑动 划出下一页 下一页可见
        alignment = Alignment.bottomCenter;
        value = 1 - aniValue;
      } else {
        /// _pageController.page < index 向下滑动 划出上一页
        alignment = Alignment.topCenter;
        value = aniValue - 1;
      }
    }
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, -0.001)
        ..rotateX(pi / 2 * value),
      alignment: alignment,
      child: child,
    );
  }
}

class StackTransform extends PageTransform {
  StackTransform();

  @override
  Widget transform(int index, double page, double aniValue, Widget child) {

    if (modifier?.scrollDirection == Axis.horizontal) {
      return horizontal(aniValue, index, page, child);
    } else {
      return vertical(aniValue, index, page, child);
    }
  }

  Transform horizontal(double aniValue, int index, double page, Widget child) {
    var alignment = Alignment.centerRight;
    var value = 1 - aniValue;
    if (index > 0) {
      if (page >= index) {
        /// _pageController.page > index 向右滑动 划出下一页 下一页可见
        alignment = Alignment.centerRight;
        value = 1 - aniValue;
      } else {
        /// _pageController.page < index 向左滑动 划出上一页
        alignment = Alignment.centerLeft;
        value = aniValue - 1;
      }
    }
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(pi / 2 * value),
      alignment: alignment,
      child: child,
    );
  }

  Transform vertical(double aniValue, int index, double page, Widget child) {
    var alignment = Alignment.centerRight;
    var value = 1 - aniValue;
    if (page >= index) {
      /// _pageController.page > index 向右滑动 划出下一页 下一页可见
      alignment = Alignment.bottomCenter;

      value = 1 - (aniValue);
      return Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, -0.001)
          ..rotateX(pi / 2 * value),
        alignment: alignment,
        child: child,
      );
    } else {
      /// _pageController.page < index 向下滑动 划出上一页
      alignment = Alignment.bottomCenter;
      double offf = 180;
      if (aniValue > 0) {
        offf = -offf + offf * Curves.easeOutQuart.transformInternal(aniValue);
      } else {
        offf = -offf + offf * aniValue;
      }
      // offf = -offf + offf * aniValue;
      return Transform.translate(
        offset: Offset(0, offf),
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, -0.001)
            ..rotateX(pi / 2.5 - pi / 2.5 * aniValue),
          alignment: alignment,
          child: Opacity(opacity: .5+.5*aniValue.abs(),
          child: child),
        ),
      );
    }
  }
}
