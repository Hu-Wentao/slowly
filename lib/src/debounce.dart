import 'dart:async';

/// 防抖
/// 建议配合依赖注入使用
class Debounce<T> {
  Debounce({Map<T, Timer>? locked}) : _locked = locked ?? {};
  final Map<T, Timer> _locked;

  ///
  /// [duration]
  ///   null: query [tag] is locked;
  ///   not null: query [tag], and set [tag] 's [duration] if
  /// return:
  ///   tag has locked
  bool duration(T tag, {Duration? duration}) {
    final timer = _locked[tag];
    final timerLocked = timer?.isActive ?? false;

    // query
    if (timerLocked) return true;
    if (duration == null) return timerLocked;

    // set timer
    if (timer != null) timer.cancel();
    _locked[tag] = Timer(duration, () => _locked.remove(tag));
    return false;
  }
}
