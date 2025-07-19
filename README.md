## Features

* debounce

* throttle

## Getting started



## Usage

```dart
import 'package:slowly/slowly.dart';

final sly = Slowly<String>();

/// debounce
bool access1 = sly.duration('foo', SlowlyTp.debounce, const Duration(milliseconds: 100));
bool access2 = sly.ms('foo', ms: 100, tp: SlowlyTp.debounce);
bool access3 = sly.seconds('foo', sec: 1, tp: SlowlyTp.debounce);

/// throttle
bool access4 = sly.duration('foo', SlowlyTp.throttle, const Duration(milliseconds: 100));

```

## Additional information


