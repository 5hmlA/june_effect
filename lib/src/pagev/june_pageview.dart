import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef AniItemBuilder = Widget Function(
    BuildContext context, int index, double page, double aniValue);

@immutable
class JunePageView extends StatefulWidget {
  final IndexedWidgetBuilder? itemBuilder;
  final AniItemBuilder? aniItemBuilder;
  final ValueChanged<int>? onPageChanged;
  final PageController? controller;
  final PageTransform? transform;
  final int? cacheItemSize;
  final int? itemCount;

  const JunePageView({
    Key? key,
    required this.itemBuilder,
    this.onPageChanged,
    this.transform = const CubeTransform(),
    this.controller,
    this.itemCount,
    this.cacheItemSize = 4,
  })  : aniItemBuilder = null,
        super(key: key);

  const JunePageView.aniBuilder({
    Key? key,
    required this.aniItemBuilder,
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
    _pageController = widget.controller ?? PageController();
    _pageController.addListener(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.itemCount,
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
    if (!_pageController.position.hasContentDimensions || _pageController.page == null) {
      return aniItemBuilder(context, index, 0.0, 1.0);
    }

    ///开始做动画
    return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          final double aniValue = 1 - (_pageController.page! - index).abs();
          return aniItemBuilder(context, index, _pageController.page!, aniValue);
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
    if (!_pageController.position.hasContentDimensions || _pageController.page == null) {
      return item;
    }

    ///开始做动画
    return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          final double changing = 1 - (_pageController.page! - index).abs();
          return widget.transform!.transform(index, _pageController.page!, changing, item!);
        });
  }
}

abstract class PageTransform {
  const PageTransform();

  Widget transform(int index, double page, double aniValue, Widget child);
}

@immutable
class CubeTransform extends PageTransform {
  const CubeTransform();

  @override
  Widget transform(int index, double page, double aniValue, Widget child) {
    if (aniValue < 0) {
      return const SizedBox();
    }
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
}
