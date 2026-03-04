# Slowly

[简体中文](./README_zh.md)

A lightweight Dart utility for managing multiple debounce, throttle, and mutex (mutual exclusion) instances. Perfect for handling rapid user input, limiting expensive API calls, and preventing overlapping asynchronous tasks.

## Features

- **🛡️ Mutex (Mutual Exclusion):** Ensures only one instance of an asynchronous task for a given tag is running at a time. Subsequent triggers are ignored until the current one completes.
- **⏲️ Debounce:** Delays execution until a specified period of inactivity has passed. Includes an optional `maxDuration` to prevent "infinite postponement" from frequent triggers.
- **⏱️ Throttle:** Executes the task immediately and then enters a "cooling period" where subsequent calls are ignored (or optionally queued as a single final execution).
- **🏷️ Tagged Instances:** Manage multiple independent instances of these behaviors easily using unique tags (strings, enums, or any comparable type).
- **🧹 Resource Management:** Easily cancel individual debounce tasks or dispose of all timers at once.

## Usage

### Getting Started

Import the package:

```dart
import 'package:slowly/slowly.dart';
```

Initialize `Slowly`:

```dart
// Use any type for tags (String, Enum, int, etc.)
final sly = Slowly<String>();
```

### 1. Mutex (Exhaust)

Useful for preventing duplicate uploads or form submissions while one is already in progress.

```dart
void uploadData() async {
  final result = await sly.mutex('upload-tag', () async {
    // This code only runs if 'upload-tag' is not already locked.
    print('Uploading...');
    await Future.delayed(Duration(seconds: 1));
    return 'Success';
  });

  if (result == null) {
    print('Upload already in progress, skipping this call.');
  } else {
    print('Upload finished: $result');
  }
}
```

### 2. Debounce

Commonly used for search-as-you-type fields or auto-saving.

```dart
void onSearchChanged(String query) {
  sly.debounce(
    'search-tag',
    () {
      print('Searching for: $query');
      // Perform API call here
    },
    duration: Duration(milliseconds: 500),
    // Optional: Force execution after 2 seconds even if typing continues.
    maxDuration: Duration(seconds: 2),
  );
}
```

### 3. Throttle

Ideal for window resize events, scroll listeners, or preventing button mash.

```dart
void onButtonClick() {
  sly.throttle(
    'button-tag',
    () {
      print('Button action executed!');
    },
    duration: Duration(milliseconds: 500),
    // Optional: Ensures the final click eventually fires after the cooling period.
    ensureLast: true,
  );
}
```

### Resource Management

```dart
// Check if a tag is currently active/locked
bool isBusy = sly.isMutexLocked('tag');

// Cancel a pending debounce
sly.cancelDebounce('search-tag');

// Clean up everything (e.g., in a StatefulWidget's dispose method)
sly.dispose();
```

## Additional Information

`Slowly` is designed to be simple and efficient. It doesn't require any complex setup or external dependencies.

For more detailed examples, check the [example](example/main.dart) folder.
