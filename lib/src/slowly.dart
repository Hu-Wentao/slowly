import 'dart:async';
import 'dart:core';

///
class Slowly<T> {
  Map<T, MapEntry<Timer, Completer>>? __debounceLocked;
  List<T>? __throttleLocked;

  /// --------------------------------------------------------------------------

  Map<T, MapEntry<Timer, Completer>> get _deLock => __debounceLocked ??= {};

  void cancelDeLock(T tag) {
    final lock = _deLock[tag];
    if (lock == null) return;

    lock.key.cancel();
    lock.value.complete(null);
    _deLock.remove(tag);
  }

  Future<F?> debounce<F>(
    T tag,
    F func, {
    required Duration duration,
  }) async {
    cancelDeLock(tag);

    final cm = Completer<F?>();
    _deLock[tag] = MapEntry(
      Timer(duration, () {
        cm.complete(func);
        _deLock.remove(tag);
      }),
      cm,
    );
    return cm.future;
  }

  /// --------------------------------------------------------------------------

  List<T> get _thLock => __throttleLocked ??= [];

  bool isThrottleLocked(T tag) => _thLock.contains(tag);

  /// [duration] null: only check [tag]
  F? throttle<F>(
    T tag,
    F func, {
    required Duration duration,
  }) {
    if (isThrottleLocked(tag)) return null;

    _thLock.add(tag);
    Timer(duration, () => _thLock.remove(tag));
    return func;
  }

  void dispose() {
    //
    _deLock.keys.map(cancelDeLock);
    //
    _thLock.clear();
  }
}
