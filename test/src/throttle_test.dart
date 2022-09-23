import 'package:flutter_test/flutter_test.dart';
import 'package:slowly/slowly.dart';

final _globalThrottle = Throttle<String>();

main() {
  test("Throttle", () async {
    int tryInvoke = 5;
    final resultSet = <String?>[];
    while (tryInvoke-- > 0) {
      await Future.delayed(const Duration(milliseconds: 50));
      resultSet.add(fooWithThrottle());
    }
    await Future.delayed(const Duration(milliseconds: 110));
    resultSet.add(fooWithThrottle());

    /// ["bar", null, "bar", null, "bar", "bar"]
    expect(resultSet.length, 6);
    expect(resultSet.where((_) => _ != null).length, 4);
  });
}

String? fooWithThrottle() =>
    _globalThrottle.duration(const Duration(milliseconds: 100), 'foo')
        ? foo()
        : null;

String foo() {
  return "bar";
}
