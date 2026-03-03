import 'package:test/test.dart';
import 'package:slowly/slowly.dart';

main() {
  test('debounce', () async {
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
    sly.debounce('tag', () => foo('00'), duration: duration);
    expect(rst, 0);
    await Future.delayed(const Duration(milliseconds: 100));
    expect(rst, 0);
    // 100-100
    sly.debounce('tag', () => foo('11'), duration: duration);
    expect(rst, 0);
    // 200-0
    await Future.delayed(const Duration(milliseconds: 100));
    expect(rst, 0);
    // 200-100
    sly.debounce('tag', () => foo('22'), duration: duration);
    expect(rst, 0);
    // 200-0

    await Future.delayed(const Duration(milliseconds: 550));
    expect(rst, 1);
    // 700-500: 22

    await Future.delayed(const Duration(milliseconds: 100));
    // 800-0
    sly.debounce('tag', () => foo('33'), duration: duration);
    expect(rst, 1);
    await Future.delayed(const Duration(milliseconds: 550));
    expect(rst, 2);

    /// ------
    final e = DateTime.now();
    print('${e} ## end; ${e.difference(s)}');
  });

  test('debounce maxDuration', () async {
    final sly = Slowly<String>();
    int rst = 0;
    const duration = Duration(milliseconds: 500);
    const maxDuration = Duration(milliseconds: 800);

    // Initial trigger
    sly.debounce('tag', () => rst++, duration: duration, maxDuration: maxDuration);
    
    // Trigger every 300ms. Without maxDuration, it would never fire.
    await Future.delayed(const Duration(milliseconds: 300));
    sly.debounce('tag', () => rst++, duration: duration, maxDuration: maxDuration);
    expect(rst, 0);

    await Future.delayed(const Duration(milliseconds: 300));
    sly.debounce('tag', () => rst++, duration: duration, maxDuration: maxDuration);
    expect(rst, 0);

    await Future.delayed(const Duration(milliseconds: 300)); // Total 900ms passed since first call
    // maxDuration (800ms) should have been triggered
    expect(rst, 1);
  });
}
