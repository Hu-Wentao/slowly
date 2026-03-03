import 'package:test/test.dart';
import 'package:slowly/slowly.dart';
import 'dart:async';

void main() {
  group('Mutex Tests', () {
    late Slowly<String> sly;

    setUp(() {
      sly = Slowly<String>();
    });

    tearDown(() {
      sly.dispose();
    });

    test('mutex should allow only one execution at a time', () async {
      int counter = 0;
      
      // First call - starts and takes some time
      final f1 = sly.mutex('tag', () async {
        await Future.delayed(Duration(milliseconds: 200));
        counter++;
        return 'first';
      });

      // Second call - should be dropped immediately
      final f2 = sly.mutex('tag', () async {
        counter++;
        return 'second';
      });

      expect(await f2, isNull, reason: 'Second call should return null while first is running');
      expect(await f1, equals('first'));
      expect(counter, equals(1), reason: 'Only the first call should have incremented the counter');
    });

    test('mutex should be available again after task completes', () async {
      int counter = 0;
      
      await sly.mutex('tag', () async {
        counter++;
      });
      
      expect(counter, 1);
      
      await sly.mutex('tag', () async {
        counter++;
      });
      
      expect(counter, 2);
    });

    test('mutex should handle errors and release lock', () async {
      try {
        await sly.mutex('tag', () async {
          throw Exception('test error');
        });
      } catch (e) {
        // ignore
      }

      expect(sly.isMutexLocked('tag'), isFalse, reason: 'Lock should be released even on error');
      
      int counter = 0;
      await sly.mutex('tag', () => counter++);
      expect(counter, 1, reason: 'Mutex should be usable after an error');
    });
  });
}
