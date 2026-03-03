import 'dart:async';
import 'package:test/test.dart';
import '../lib/src/slowly.dart';

void main() {
  final slowly = Slowly<String>();

  test('Stack trace in mutex (current approach)', () async {
    try {
      await slowly.mutex('test', () async {
        await Future.delayed(Duration(milliseconds: 10));
        throw Exception('Error in action');
      });
    } catch (e, s) {
      print('--- Stack Trace ---');
      print(s);
      print('-------------------');
    }
  });

  test('Stack trace in mutex (direct await)', () async {
    // Simulated direct await approach
    Future<R?> mutexDirect<R>(String tag, FutureOr<R> Function() action) async {
      try {
        return await action();
      } finally {
        // Mock cleanup
      }
    }

    try {
      await mutexDirect('test', () async {
        await Future.delayed(Duration(milliseconds: 10));
        throw Exception('Error in action');
      });
    } catch (e, s) {
      print('--- Stack Trace (Direct) ---');
      print(s);
      print('----------------------------');
    }
  });
}
