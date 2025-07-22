import 'package:flutter_test/flutter_test.dart';
import 'package:slowly/slowly.dart';

main() {
  test('throttle', () async {
    final sly = Slowly();
    Future<F?> throttle<F extends Function>(
      String tag,
      F func, {
      Duration duration = const Duration(milliseconds: 500),
    }) async =>
        sly.throttle(tag, func, duration: duration);

    int rst = 0;
    foo(p) {
      print('${DateTime.now()} ## $p');
      rst += 1;
      return 'foo: $p';
    }

    final s = DateTime.now();
    print('${s} ## start');
    expect(rst, 0);

    /// ------

    // 0
    throttle('tag', () => foo('00')).then((e) => e?.call());
    expect(rst, 0);
    await Future.delayed(const Duration(milliseconds: 100));
    expect(rst, 1);
    // 100-100
    throttle('tag', () => foo('11')).then((e) => e?.call());
    expect(rst, 1);
    // 200-0
    await Future.delayed(const Duration(milliseconds: 100));
    expect(rst, 1);
    // 200-100
    throttle('tag', () => foo('22')).then((e) => e?.call());
    expect(rst, 1);
    // 200-0

    await Future.delayed(const Duration(milliseconds: 550));
    expect(rst, 1);
    // 700-500: 22

    await Future.delayed(const Duration(milliseconds: 100));
    // 800-0
    throttle('tag', () => foo('33')).then((e) => e?.call());
    expect(rst, 1);
    await Future.delayed(const Duration(milliseconds: 550));
    expect(rst, 2);
    // 800-0

    /// ------
    final e = DateTime.now();
    print('${e} ## end; ${e.difference(s)}');
  });
}

/// de3 ok
