## 0.4.4 2026-03-04
* doc: update README and example for better clarity and accessibility
* feat: add internationalization support (README_zh.md)
* chore: fix lint issues in tests

## 0.4.3 2026-03-04
* fix: FutureOr check

## 0.4.2 2026-03-03
* fix: optimize stack traces for mutex, throttle, and debounce by using FutureOr
* fix: avoid Completer hanging on error in debounce

## 0.4.1 2026-03-03
* chore: remove flutter dependency, transform to pure dart package

## 0.4.0 2026-03-03
* feat: add mutex; 
* fix: debounce and throttle with maxDuration and ensureLast

## 0.3.0 2025-7-22
* refactor Slowly, debounce/throttle support callback

## 0.2.0
* feat Debounce::isUnlock, Throttle::isUnlock

## 0.1.0

* Added Debounce, Throttle and Slowly