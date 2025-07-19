import 'package:flutter_test/flutter_test.dart';
import 'package:slowly/slowly.dart';

final _globalSlowly = Slowly<String>();

main() {
  test("Slowly SlowlyTp.throttle", () async {
    int tryInvoke = 5;
    final resultSet = <String?>[];
    while (tryInvoke-- > 0) {
      await Future.delayed(const Duration(milliseconds: 50));
      resultSet.add(fooWithSlowly(SlowlyTp.throttle));
    }
    await Future.delayed(const Duration(milliseconds: 110));
    resultSet.add(fooWithSlowly(SlowlyTp.throttle));

    /// ["bar", null, "bar", null, "bar", "bar"]
    expect(resultSet.length, 6);
    expect(resultSet.where((_) => _ != null).length, 4);
  });

  test("Slowly SlowlyTp.debounce", () async {
    int tryInvoke = 5;
    final resultSet = <String?>[];
    while (tryInvoke-- > 0) {
      await Future.delayed(const Duration(milliseconds: 50));
      resultSet.add(fooWithSlowly(SlowlyTp.debounce));
    }
    await Future.delayed(const Duration(milliseconds: 110));
    resultSet.add(fooWithSlowly(SlowlyTp.debounce));

    /// [null, null, null, null, null, "bar"]
    expect(resultSet.length, 6);
    expect(resultSet.where((_) => _ != null).length, 1);
  });
}

String? fooWithSlowly(SlowlyTp tp) =>
    _globalSlowly.duration('foo', tp, const Duration(milliseconds: 100))
        ? foo()
        : null;

String foo() {
  return "bar";
}
