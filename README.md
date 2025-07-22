## Features

* debounce

* throttle

## Getting started

## Usage

```dart
import 'package:slowly/slowly.dart';

main() async {
  /// <String>: tag type
  final sly = Slowly<String>();

  foo() {
    print('foo func');
    return 'foo!';
  }

  /// debounce
  /// need 'await'
  final fnFoo = await sly.debounce(
    'foo',
    foo,
    duration: const Duration(milliseconds: 100),
  );
  if (fnFoo == null) return; // if locked, fnFoo will be null
  final r = fnFoo();
  print('debounce result: $r');

  /// throttle
  /// not need 'await'
  final fnFoo2 = sly.throttle(
    'bar',
    foo,
    duration: const Duration(milliseconds: 100),
  );
  if (fnFoo2 == null) return; // if locked, fnFoo will be null
  final r2 = fnFoo2();
  print('throttle result: $r2');
}
```

## Additional information


