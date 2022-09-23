import 'dart:async';

/// 节流
/// 建议配合依赖注入使用
class Throttle<T> {
  Throttle({List<T>? locked}) : _locked = locked ?? [];
  final List<T> _locked;

  bool duration(Duration duration, T tag) {
    if (_locked.contains(tag)) return false;
    _locked.add(tag);
    Timer(duration, () => _locked.remove(tag));
    return true;
  }
}
