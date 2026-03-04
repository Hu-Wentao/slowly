# Slowly

[English](./README.md)

一个轻量级的 Dart 工具类，用于管理多个防抖 (Debounce)、节流 (Throttle) 和互斥锁 (Mutex) 实例。非常适合处理频繁的用户输入、限制高开销的 API 调用以及防止异步任务重叠。

## 特性

- **🛡️ 互斥锁 (Mutex/Exhaust):** 确保针对特定标签的异步任务同一时间只有一个在运行。任务运行期间的后续触发将被忽略，直到当前任务完成。
- **⏲️ 防抖 (Debounce):** 延迟执行，直到停止操作后的指定时间段。包含可选的 `maxDuration`（最大持续时间），防止频繁触发导致的“无限期延迟”。
- **⏱️ 节流 (Throttle):** 立即执行任务，随后进入“冷却期”，期间的后续调用将被忽略（或者可选地作为最后一个任务执行）。
- **🏷️ 标签化实例:** 使用唯一标签（字符串、枚举或任何可比较类型）轻松管理多个独立的行为实例。
- **🧹 资源管理:** 轻松取消特定的防抖任务或一次性释放所有定时器。

## 使用方法

### 开始使用

导入包：

```dart
import 'package:slowly/slowly.dart';
```

初始化 `Slowly`：

```dart
// 可以使用任何类型作为标签 (String, Enum, int 等)
final sly = Slowly<String>();
```

### 1. 互斥锁 (Mutex)

适用于防止在上传或表单提交正在进行时发生重复调用。

```dart
void uploadData() async {
  final result = await sly.mutex('upload-tag', () async {
    // 仅当 'upload-tag' 未被锁定阶段时执行
    print('正在上传...');
    await Future.delayed(Duration(seconds: 1));
    return '成功';
  });

  if (result == null) {
    print('上传已在进行中，跳过本次调用。');
  } else {
    print('上传完成: $result');
  }
}
```

### 2. 防抖 (Debounce)

通常用于搜索输入框或自动保存。

```dart
void onSearchChanged(String query) {
  sly.debounce(
    'search-tag',
    () {
      print('正在搜索: $query');
      // 在此处执行 API 调用
    },
    duration: Duration(milliseconds: 500),
    // 可选：即使输入一直在持续，也在 2 秒后强制执行一次。
    maxDuration: Duration(seconds: 2),
  );
}
```

### 3. 节流 (Throttle)

适用于窗口大小调整事件、滚动监听器或防止按钮连点。

```dart
void onButtonClick() {
  sly.throttle(
    'button-tag',
    () {
      print('按钮动作已执行！');
    },
    duration: Duration(milliseconds: 500),
    // 可选：确保冷却期后的最后一次点击最终会被触发。
    ensureLast: true,
  );
}
```

### 资源管理

```dart
// 检查标签是否处于活动/锁定状态
bool isBusy = sly.isMutexLocked('tag');

// 取消挂起的防抖
sly.cancelDebounce('search-tag');

// 清理所有资源 (例如，在 StatefulWidget 的 dispose 方法中)
sly.dispose();
```

## 其他信息

`Slowly` 旨在简单高效。它不需要任何复杂的配置或外部依赖。

更多详细示例，请查看 [example](example/main.dart) 文件夹。
