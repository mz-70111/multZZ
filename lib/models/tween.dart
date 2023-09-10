import 'dart:math';

import 'package:flutter/widgets.dart';

class TweenMz {
  static TweenM(
      {ctx, begin, end, duration, childm, Curve curve = Curves.linear}) {
    return TweenAnimationBuilder<double>(
        curve: curve,
        tween: Tween(begin: begin, end: end),
        duration: Duration(milliseconds: duration),
        builder: (ctx, end0, child0) {
          return childm(end0);
        });
  }

  static opacityM({ctx, begin, end, duration, child, curve = Curves.linear}) {
    return TweenM(
        curve: curve,
        duration: duration,
        ctx: ctx,
        begin: begin,
        end: end,
        childm: (end) => Opacity(opacity: end, child: child));
  }

  static scaleYM(
      {ctx, begin, end, duration, child, alignment, curve = Curves.linear}) {
    return TweenM(
        curve: curve,
        duration: duration,
        ctx: ctx,
        begin: begin,
        end: end,
        childm: (end) => Transform.scale(
            scaleX: 1.0,
            scaleY: end.toDouble(),
            alignment: alignment,
            child: child));
  }

  static scaleXM(
      {ctx, begin, end, duration, child, alignment, curve = Curves.linear}) {
    return TweenM(
        curve: curve,
        duration: duration,
        ctx: ctx,
        begin: begin,
        end: end,
        childm: (end) => Transform.scale(
            scaleX: end, scaleY: 0.0, alignment: alignment, child: child));
  }

  static rotateM({
    ctx,
    begin,
    end,
    duration,
    child,
    alignment,
    curve = Curves.linear,
  }) {
    return TweenM(
        curve: curve,
        duration: duration,
        ctx: ctx,
        begin: begin,
        end: end,
        childm: (end) => Transform.rotate(
            angle: (end.toDouble()) * pi / 180,
            alignment: alignment,
            child: child));
  }

  static translateYM(
      {ctx, begin, end, duration, child, curve = Curves.linear, angle}) {
    return TweenM(
        curve: curve,
        duration: duration,
        ctx: ctx,
        begin: begin,
        end: end,
        childm: (end) =>
            Transform.translate(offset: Offset(0.0, end), child: child));
  }

  static translateXM(
      {ctx, begin, end, duration, child, curve = Curves.linear, angle}) {
    return TweenM(
        curve: curve,
        duration: duration,
        ctx: ctx,
        begin: begin,
        end: end,
        childm: (end) =>
            Transform.translate(offset: Offset(end, 0.0), child: child));
  }
}
