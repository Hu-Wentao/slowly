import 'package:slowly/slowly.dart';

void main() async {
  final sly = Slowly<String>();

  foo() {
    print('Executing foo...');
    return 'result of foo';
  }

  print('--- Debounce Example ---');
  // Debounce will wait for 500ms of silence before executing.
  // We call it multiple times, but only the last one will execute.
  for (int i = 0; i < 5; i++) {
    print('Calling debounce $i');
    sly
        .debounce(
      'my-tag',
      foo,
      duration: const Duration(milliseconds: 500),
      // maxDuration ensures it executes even if calls keep coming.
      maxDuration: const Duration(seconds: 2),
    )
        .then((result) {
      if (result != null) {
        print('Debounce finished: $result');
      }
    });
    await Future.delayed(const Duration(milliseconds: 100));
  }

  await Future.delayed(const Duration(seconds: 1));

  print('\n--- Throttle Example ---');
  // Throttle will execute immediately and then ignore subsequent calls for 1 second.
  for (int i = 0; i < 5; i++) {
    print('Calling throttle $i');
    final result = await sly.throttle(
      'my-throttle-tag',
      foo,
      duration: const Duration(seconds: 1),
      ensureLast: true, // This will ensure the last call eventually runs.
    );
    if (result != null) {
      print('Throttle result: $result');
    }
    await Future.delayed(const Duration(milliseconds: 200));
  }

  // Wait for the ensureLast (debounce) to fire.
  await Future.delayed(const Duration(seconds: 2));

  sly.dispose();
}
