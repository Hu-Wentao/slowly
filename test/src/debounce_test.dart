import 'package:flutter_test/flutter_test.dart';
import 'package:slowly/slowly.dart';

final _globalDebounce = Debounce<String>();

main() {
  test("debounce", () async {
    int tryInvoke = 5;
    final resultSet = <String?>[];
    while (tryInvoke-- > 0) {
      await Future.delayed(const Duration(milliseconds: 50));
      resultSet.add(fooWithDebounce());
    }
    await Future.delayed(const Duration(milliseconds: 110));
    resultSet.add(fooWithDebounce());

    /// [null, null, null, null, null, "bar"]
    expect(resultSet.length, 6);
    expect(resultSet.where((_) => _ != null).length, 1);
  });
}

String? fooWithDebounce() =>
    _globalDebounce.duration('foo', duration: const Duration(milliseconds: 100))
        ? foo()
        : null;

String foo() {
  return "bar";
}
