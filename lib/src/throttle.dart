import 'dart:async';

/// 节流
/// 建议配合依赖注入使用
class Throttle<T> {
  Throttle({List<T>? locked}) : _locked = locked ?? [];
  final List<T> _locked;

  bool isUnlock(T tag) => _locked.contains(tag);

  /// [duration] null: only check [tag]
  bool duration(
    T tag, {
    required Duration duration,
    void Function()? callback,
  }) {
    if (isUnlock(tag)) {
      callback?.call();
      _locked.add(tag);
      Timer(duration, () => _locked.remove(tag));
      return true;
    }
    return false;
  }
}
