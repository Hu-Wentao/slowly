import 'package:test/test.dart';
import 'package:slowly/slowly.dart';
import 'dart:async';

void main() {
  group('Throttle Tests', () {
    late Slowly<String> sly;

    setUp(() {
      sly = Slowly<String>();
    });

    tearDown(() {
      sly.dispose();
    });

    test('throttle basic - Leading edge should fire immediately', () async {
      int counter = 0;
      final duration = Duration(milliseconds: 300);

      sly.throttle('tag', () => counter++, duration: duration);
      expect(counter, 1, reason: 'Leading edge fires immediately');

      sly.throttle('tag', () => counter++, duration: duration);
      expect(counter, 1, reason: 'Second call within cooling period is dropped');

      await Future.delayed(Duration(milliseconds: 400));
      sly.throttle('tag', () => counter++, duration: duration);
      expect(counter, 2, reason: 'Should fire after cooling period');
    });

    test('throttle ensureLast - should fire final call after cooling period', () async {
      int counter = 0;
      final duration = Duration(milliseconds: 300);

      sly.throttle('tag', () => counter++, duration: duration, ensureLast: true); // 1
      sly.throttle('tag', () => counter++, duration: duration, ensureLast: true); // queued as debounce
      sly.throttle('tag', () => counter++, duration: duration, ensureLast: true); // updates queue
      
      expect(counter, 1);
      
      await Future.delayed(Duration(milliseconds: 450)); // cooling (300) + debounce buffer
      expect(counter, 2, reason: 'Last call should have fired via debounce mechanism');
    });

    test('throttle mutex interaction - skip if task is slow', () async {
      int counter = 0;
      final duration = Duration(milliseconds: 200);

      // Start slow task
      sly.throttle('tag', () async {
        await Future.delayed(Duration(milliseconds: 500));
        counter++;
      }, duration: duration);

      expect(counter, 0);

      // 300ms later: duration (200) has passed, but mutex is still locked (500)
      await Future.delayed(Duration(milliseconds: 300));
      final rst = await sly.throttle('tag', () => counter++, duration: duration);
      
      expect(rst, isNull, reason: 'Should skip because mutex is locked');
      expect(counter, 0);

      await Future.delayed(Duration(milliseconds: 300)); // Total 600ms, task finished
      expect(counter, 1);
    });
  });
}
