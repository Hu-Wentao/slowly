import 'package:test/test.dart';
import 'package:slowly/slowly.dart';
import 'dart:async';

void main() {
  group('Debounce Tests', () {
    late Slowly<String> sly;

    setUp(() {
      sly = Slowly<String>();
    });

    tearDown(() {
      sly.dispose();
    });

    test('debounce basic - should execute only last call', () async {
      int counter = 0;
      final duration = Duration(milliseconds: 200);

      sly.debounce('tag', () => counter++, duration: duration);
      sly.debounce('tag', () => counter++, duration: duration);
      sly.debounce('tag', () => counter++, duration: duration);

      await Future.delayed(Duration(milliseconds: 100));
      expect(counter, 0, reason: 'Wait for silence');

      await Future.delayed(Duration(milliseconds: 150));
      expect(counter, 1, reason: 'Execute only the last one after silence');
    });

    test('debounce maxDuration - ensure execution under frequent calls', () async {
      int counter = 0;
      final duration = Duration(milliseconds: 300);
      final maxDuration = Duration(milliseconds: 500);

      // Start first call
      sly.debounce('tag', () => counter++, duration: duration, maxDuration: maxDuration);

      // Continuous triggers every 200ms (less than duration)
      await Future.delayed(Duration(milliseconds: 200));
      sly.debounce('tag', () => counter++, duration: duration, maxDuration: maxDuration);
      expect(counter, 0);

      await Future.delayed(Duration(milliseconds: 200));
      sly.debounce('tag', () => counter++, duration: duration, maxDuration: maxDuration);
      expect(counter, 0);

      // Now it should have passed maxDuration (200 + 200 + some small time)
      // We wait a bit more for the next trigger or the capped timer to fire
      await Future.delayed(Duration(milliseconds: 150)); 
      expect(counter, 1, reason: 'maxDuration should force execution despite continuous triggers');
    });

    test('debounce cancel - should stop execution', () async {
      int counter = 0;
      final duration = Duration(milliseconds: 200);

      sly.debounce('tag', () => counter++, duration: duration);
      sly.cancelDebounce('tag');

      await Future.delayed(Duration(milliseconds: 300));
      expect(counter, 0, reason: 'Task should be cancelled');
    });
  });
}
