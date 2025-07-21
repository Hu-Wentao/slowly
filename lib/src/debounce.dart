import 'dart:async';

/// 防抖
/// 建议配合依赖注入使用
class Debounce<T> {
  Debounce({Map<T, Timer>? locked}) : _locked = locked ?? {};
  final Map<T, Timer> _locked;

  bool isUnlock(T tag) => !(_locked[tag]?.isActive ?? false);

  ///
  /// [duration]
  ///   null: query [tag] is locked;
  ///   not null: query [tag], and set [tag] 's [duration] if
  /// return:
  ///   tag has locked
  bool duration(T tag,
      {required Duration duration, void Function()? callback}) {
    if (isUnlock(tag)) return true;
    // set timer
    _locked[tag]?.cancel();
    _locked[tag] = Timer(duration, () {
      _locked.remove(tag);
      callback?.call();
    });
    return isUnlock(tag);
  }
}
