import 'dart:core';

import 'package:slowly/src/debounce.dart';
import 'package:slowly/src/throttle.dart';

enum SlowlyTp { debounce, throttle }

///
class Slowly<T> {
  final Throttle<T> _throttle;
  final Debounce<T> _debounce;

  Slowly({Throttle<T>? throttle, Debounce<T>? debounce})
      : _throttle = throttle ?? Throttle<T>(),
        _debounce = debounce ?? Debounce<T>();

  /// debounce, 500ms
  bool ms(
    T tag, {
    SlowlyTp tp = SlowlyTp.debounce,
    int ms = 500,
  }) =>
      duration(Duration(milliseconds: ms), tag, tp);

  /// throttle, 5s
  bool seconds(
    T tag, {
    SlowlyTp tp = SlowlyTp.throttle,
    int sec = 5,
  }) =>
      duration(Duration(seconds: sec), tag, tp);

  bool duration(Duration duration, T tag, SlowlyTp tp) {
    switch (tp) {
      case SlowlyTp.debounce:
        return _debounce.duration(duration, tag);
      case SlowlyTp.throttle:
        return _throttle.duration(duration, tag);
    }
  }
}
