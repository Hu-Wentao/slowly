import 'dart:async';

/// 防抖
/// 建议配合依赖注入使用
class Debounce<T> {
  Debounce({Map<T, Timer>? locked}) : _locked = locked ?? {};
  final Map<T, Timer> _locked;

  bool duration(Duration duration, T tag) {
    final timer = _locked[tag];
    if (timer != null && !timer.isActive) return true;

    _locked[tag] = Timer(duration, () {});
    return false;
  }
}
