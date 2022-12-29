import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nb_utils/nb_utils.dart';

import 'constant.dart';

class SelectedAnimationType extends StatefulWidget {
  static String tag = '/SelectedAnimationType';
  final Widget child;
  final Curve? curves;
  final double? viewOffset;
  final Duration? duration;
  final Duration? delay;
  final double? scale;
  final FlipAxis? flipAxis;

  SelectedAnimationType({required this.child, this.curves, this.viewOffset, this.duration, this.delay, this.scale, this.flipAxis});

  @override
  SelectedAnimationTypeState createState() => SelectedAnimationTypeState();
}

class SelectedAnimationTypeState extends State<SelectedAnimationType> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return (getIntAsync(ANIMATION_TYPE_SELECTION_INDEX) == SLIDE_ANIMATION)
        ? SlideAnimation(
            verticalOffset: widget.viewOffset ?? 50.0,
            curve: widget.curves ?? Curves.ease,
            child: FadeInAnimation(child: widget.child),
            duration: widget.duration ?? Duration(milliseconds: 600),
            delay: widget.delay ?? Duration(),
          )
        : (getIntAsync(ANIMATION_TYPE_SELECTION_INDEX) == SCALE_ANIMATION)
            ? ScaleAnimation(
                duration: widget.duration ?? Duration(milliseconds: 600),
                curve: widget.curves ?? Curves.ease,
                delay: widget.delay ?? Duration(),
                scale: widget.scale ?? 0.0,
                child: FadeInAnimation(child: widget.child),
              )
            : (getIntAsync(ANIMATION_TYPE_SELECTION_INDEX) == FLIP_ANIMATION)
                ? FlipAnimation(
                    duration: widget.duration ?? Duration(milliseconds: 600),
                    curve: widget.curves ?? Curves.ease,
                    delay: widget.delay ?? Duration(),
                    flipAxis: widget.flipAxis ?? FlipAxis.x,
                    child: FadeInAnimation(child: widget.child),
                  )
                : SlideAnimation(
                    verticalOffset: widget.viewOffset ?? 50.0,
                    curve: widget.curves ?? Curves.ease,
                    child: FadeInAnimation(child: widget.child),
                    duration: widget.duration ?? Duration(milliseconds: 600),
                    delay: widget.delay ?? Duration(),
                  );
  }
}
