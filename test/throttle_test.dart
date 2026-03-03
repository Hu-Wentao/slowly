import 'package:flutter_test/flutter_test.dart';
import 'package:slowly/slowly.dart';

main() {
  test('throttle', () async {
    final sly = Slowly<String>();

    int rst = 0;
    foo(p) {
      print('${DateTime.now()} ## $p');
      rst += 1;
      return 'foo: $p';
    }

    final s = DateTime.now();
    print('${s} ## start');
    expect(rst, 0);

    const duration = Duration(milliseconds: 500);

    /// ------

    // 0
    sly.throttle('tag', () => foo('00'), duration: duration);
    expect(rst, 1); // Leading edge
    await Future.delayed(const Duration(milliseconds: 100));
    expect(rst, 1);
    // 100-100
    sly.throttle('tag', () => foo('11'), duration: duration);
    expect(rst, 1);
    // 200-0
    await Future.delayed(const Duration(milliseconds: 100));
    expect(rst, 1);
    // 200-100
    sly.throttle('tag', () => foo('22'), duration: duration);
    expect(rst, 1);

    await Future.delayed(const Duration(milliseconds: 550));
    expect(rst, 1);

    await Future.delayed(const Duration(milliseconds: 100));
    // 800-0
    sly.throttle('tag', () => foo('33'), duration: duration);
    expect(rst, 2);
    await Future.delayed(const Duration(milliseconds: 550));
    expect(rst, 2);

    /// ------
    final e = DateTime.now();
    print('${e} ## end; ${e.difference(s)}');
  });

  test('throttle mutex overlap', () async {
    final sly = Slowly<String>();
    int rst = 0;
    const duration = Duration(milliseconds: 200);

    // Fast interval, slow task
    sly.throttle('tag', () async {
      await Future.delayed(const Duration(milliseconds: 500));
      rst++;
    }, duration: duration);
    
    expect(rst, 0);

    await Future.delayed(const Duration(milliseconds: 300));
    // duration (200) passed, but task is still running (500)
    // throttle should skip because of mutex
    sly.throttle('tag', () => rst++, duration: duration);
    expect(rst, 0);

    await Future.delayed(const Duration(milliseconds: 300)); // Total 600
    expect(rst, 1);
    
    // Now it should be free
    sly.throttle('tag', () => rst++, duration: duration);
    expect(rst, 2);
  });
}
