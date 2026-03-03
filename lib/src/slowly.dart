import 'dart:async';

/// A utility class for managing multiple debounce, throttle, and mutex instances.
class Slowly<T> {
  final Map<T, Timer> _deTimers = {};
  final Map<T, Completer<dynamic>> _deCompleters = {};
  final Map<T, DateTime> _deFirstCalls = {};

  final Map<T, Timer> _thTimers = {};
  final Set<T> _mxLocks = {};

  /// [mutex] 互斥锁 (Exhaust): 立即执行，执行期间的触发直接丢弃。
  /// 解决异步任务重叠问题。
  FutureOr<R?> mutex<R>(T tag, FutureOr<R> Function() action) {
    if (_mxLocks.contains(tag)) return null;
    _mxLocks.add(tag);
    try {
      final rst = action();
      if (rst == null || rst is R) {
        _mxLocks.remove(tag);
        return rst;
      } else if (rst is Future<R> ||
          rst is Future<R?> ||
          rst is FutureOr<R> ||
          rst is FutureOr<R?>) {
        return rst.whenComplete(() => _mxLocks.remove(tag));
      } else {
        _mxLocks.remove(tag);
        return rst;
      }
    } catch (e) {
      _mxLocks.remove(tag);
      rethrow;
    }
  }

  /// [debounce] 防抖: 停止操作后等待 [duration] 执行最后一次。
  /// [maxDuration]: 可选，解决“无限重置”问题。如果持续触发超过此时间，强制执行一次。
  Future<R?> debounce<R>(
    T tag,
    FutureOr<R> Function() action, {
    required Duration duration,
    Duration? maxDuration,
  }) {
    _deTimers[tag]?.cancel();

    final now = DateTime.now();
    _deFirstCalls[tag] ??= now;
    final firstCall = _deFirstCalls[tag]!;

    final completer = _deCompleters[tag] ??= Completer<R?>();

    void execute() {
      _deTimers.remove(tag)?.cancel();
      _deFirstCalls.remove(tag);
      final cm = _deCompleters.remove(tag);
      if (cm != null && !cm.isCompleted) {
        cm.complete(mutex<R>(tag, action));
      }
    }

    final diff = now.difference(firstCall);
    if (maxDuration != null && diff >= maxDuration) {
      execute();
    } else {
      var nextDuration = duration;
      if (maxDuration != null) {
        final remainingMax = maxDuration - diff;
        if (remainingMax < nextDuration) {
          nextDuration = remainingMax;
        }
      }
      _deTimers[tag] = Timer(nextDuration, execute);
    }

    return completer.future as Future<R?>;
  }

  /// [throttle] 节流: 固定频率执行。
  /// 配合 [mutex] 解决异步任务重叠问题：如果周期到了但上次任务还没跑完，跳过。
  FutureOr<R?> throttle<R>(
    T tag,
    FutureOr<R> Function() action, {
    required Duration duration,
    bool ensureLast = false,
  }) {
    if (_thTimers.containsKey(tag) || _mxLocks.contains(tag)) {
      if (ensureLast) {
        return debounce<R>(tag, action, duration: duration);
      }
      return null;
    }

    _thTimers[tag] = Timer(duration, () => _thTimers.remove(tag));
    return mutex<R>(tag, action);
  }

  /// 检查是否正在执行 mutex 任务
  bool isMutexLocked(T tag) => _mxLocks.contains(tag);

  /// 检查是否正在防抖等待中
  bool isDebounceLocked(T tag) => _deTimers.containsKey(tag);

  /// 检查是否处于节流冷却期
  bool isThrottleLocked(T tag) => _thTimers.containsKey(tag);

  /// 取消特定 tag 的防抖
  void cancelDebounce(T tag) {
    _deTimers[tag]?.cancel();
    _deTimers.remove(tag);
    _deFirstCalls.remove(tag);
    if (_deCompleters[tag]?.isCompleted == false) {
      _deCompleters[tag]?.complete(null);
    }
    _deCompleters.remove(tag);
  }

  /// 释放所有资源
  void dispose() {
    for (var t in _deTimers.values) {
      t.cancel();
    }
    _deTimers.clear();
    _deCompleters.clear();
    _deFirstCalls.clear();

    for (var t in _thTimers.values) {
      t.cancel();
    }
    _thTimers.clear();
    _mxLocks.clear();
  }
}
