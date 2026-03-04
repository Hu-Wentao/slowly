import 'dart:async';

import 'package:test/test.dart';

Future<int> f1() async {
  return 1;
}

Future<int?> f2() async {
  return null;
}

FutureOr<int?> f3() async {
  return null;
}

FutureOr<int?> f4() {
  return null;
}

main() {
  test('test FutureOr type', () async {
    final tps = [];
    for (final rst in [f1(), f2(), f3(), f4()]) {
      if (rst is int?) {
        tps.add(true);
        print('rst is int?');
      } else {
        tps.add(false);
        print('rst is not int?');
        rst.whenComplete(() => print('done'));
      }
      print('------- ${rst.runtimeType} -------');
    }
    expect(tps, [false, false, false, true]);
  });
}
