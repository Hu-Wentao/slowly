import 'package:flutter_test/flutter_test.dart';
import 'package:slowly/slowly.dart';

main() {
  test('debounce', () async {
    final sly = Slowly();
    Future<F?> debounce<F extends Function>(
      String tag,
      F func, {
      Duration duration = const Duration(milliseconds: 500),
    }) async =>
        sly.debounce(tag, func, duration: duration);

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
    debounce('tag', () => foo('00')).then((e) => e?.call());
    expect(rst, 0);
    await Future.delayed(const Duration(milliseconds: 100));
    expect(rst, 0);
    // 100-100
    debounce('tag', () => foo('11')).then((e) => e?.call());
    expect(rst, 0);
    // 200-0
    await Future.delayed(const Duration(milliseconds: 100));
    expect(rst, 0);
    // 200-100
    debounce('tag', () => foo('22')).then((e) => e?.call());
    expect(rst, 0);
    // 200-0

    await Future.delayed(const Duration(milliseconds: 550));
    expect(rst, 1);
    // 700-500: 22

    await Future.delayed(const Duration(milliseconds: 100));
    // 800-0
    debounce('tag', () => foo('33')).then((e) => e?.call());
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
