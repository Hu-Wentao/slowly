import 'dart:core';

import 'package:slowly/src/debounce.dart';
import 'package:slowly/src/throttle.dart';

enum SlowlyTp { debounce, throttle }

///
class Slowly<T> {
  Throttle<T>? _throttle;

  Throttle<T> get throttle => _throttle ??= Throttle<T>();

  Debounce<T>? _debounce;

  Debounce<T> get debounce => _debounce ??= Debounce<T>();

  Slowly({Throttle<T>? throttle, Debounce<T>? debounce})
      : _throttle = throttle,
        _debounce = debounce;

  /// debounce, 500ms
  bool ms(
    T tag, {
    SlowlyTp tp = SlowlyTp.debounce,
    int ms = 500,
  }) =>
      duration(tag, tp, Duration(milliseconds: ms));

  /// throttle, 5s
  bool seconds(
    T tag, {
    SlowlyTp tp = SlowlyTp.throttle,
    int sec = 5,
  }) =>
      duration(tag, tp, Duration(seconds: sec));

  bool duration(T tag, SlowlyTp tp, Duration duration) {
    switch (tp) {
      case SlowlyTp.debounce:
        return debounce.duration(tag, duration: duration);
      case SlowlyTp.throttle:
        return throttle.duration(tag, duration: duration);
    }
  }
}
