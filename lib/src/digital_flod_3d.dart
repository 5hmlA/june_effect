import 'dart:math';

import 'package:flutter/cupertino.dart';

typedef CurrentBuilder = Widget Function(BuildContext context);
typedef NextBuilder = Widget Function(BuildContext context);
typedef IndexBuilder = Widget Function(BuildContext context, int index);

class DigitalsFlop extends StatefulWidget {
  final IndexBuilder indexBuilder;
  final int start;
  final int end;

  const DigitalsFlop({
    Key? key,
    required this.indexBuilder,
    required this.start,
    required this.end,
  }) : super(key: key);

  @override
  State<DigitalsFlop> createState() => _DigitalsFlopState();
}

class _DigitalsFlopState extends State<DigitalsFlop> {
  int current = 0;

  @override
  void initState() {
    super.initState();
    current = widget.start;
  }

  @override
  Widget build(BuildContext context) {
    return DigitalFlop(
      currentBuilder: (BuildContext context) {
        return widget.indexBuilder(context, current);
      },
      nextBuilder: (BuildContext context) {
        return widget.indexBuilder(context, current + 1);
      },
      listener: (status) {
        if (current < widget.end - 1 && status == AnimationStatus.completed) {
          setState(() {
            current++;
          });
        }
      },
    );
  }
}

class DigitalFlop extends StatefulWidget {
  final CurrentBuilder currentBuilder;
  final NextBuilder nextBuilder;
  final AnimationStatusListener? listener;

  const DigitalFlop({
    Key? key,
    required this.nextBuilder,
    required this.currentBuilder,
    this.listener,
  }) : super(key: key);

  @override
  _DigitalFlopState createState() => _DigitalFlopState();
}

class _DigitalFlopState extends State<DigitalFlop> with SingleTickerProviderStateMixin {
  late AnimationController _animationControl;

  @override
  void initState() {
    super.initState();
    _animationControl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    if (widget.listener != null) {
      _animationControl.addStatusListener(widget.listener!);
    }
    _animationControl.forward();
  }

  @override
  void didUpdateWidget(covariant DigitalFlop oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationControl.repeat();
    _animationControl.forward();
  }

  @override
  void dispose() {
    _animationControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [stableDigital(), animateDigital()],
    );
  }

  stableDigital() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: .5,
            child: widget.nextBuilder(context),
          ),
        ),
        const SizedBox(
          height: 1,
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: .5,
            child: widget.currentBuilder(context),
          ),
        ),
      ],
    );
  }

  /// 1--2
  animateDigital() {
    return AnimatedBuilder(
      animation: _animationControl,
      builder: (BuildContext context, Widget? child) {
        /// 0-1
        // double value = Curves.easeOutCirc.transform(_animationControl.value);
        double value = _animationControl.value;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.006)
                ..rotateX(min(value, .5) * pi),
              alignment: Alignment.bottomCenter,
              child: ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: .5,
                  child: widget.currentBuilder(context),
                ),
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            //
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.006)
                ..rotateX(-min(1 - value, .5) * pi),
              alignment: Alignment.topCenter,
              child: ClipRect(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: .5,
                  child: widget.nextBuilder(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
