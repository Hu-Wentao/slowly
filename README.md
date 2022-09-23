## Features

* debounce

* throttle

## Getting started



## Usage

```dart
import 'package:slowly/slowly.dart';

final _globalSlowly = Slowly<String>();

/// debounce
bool access1 = _globalSlowly.duration(const Duration(milliseconds: 100), 'foo', SlowlyTp.debounce);
//  _globalSlowly.ms('foo', ms: 100, tp: SlowlyTp.debounce);
//  _globalSlowly.seconds('foo', sec: 1, tp: SlowlyTp.debounce);

/// throttle
bool access2 = _globalSlowly.duration(const Duration(milliseconds: 100), 'foo', SlowlyTp.throttle);

```

## Additional information


