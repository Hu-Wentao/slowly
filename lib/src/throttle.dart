import 'dart:async';

/// 节流
/// 建议配合依赖注入使用
class Throttle<T> {
  Throttle({List<T>? locked}) : _locked = locked ?? [];
  final List<T> _locked;

  bool duration(T tag, {Duration? duration}) {
    if (_locked.contains(tag)) return false;
    _locked.add(tag);
    if (duration == null) return true;

    Timer(duration, () => _locked.remove(tag));
    return true;
  }
}
