import 'package:slowly/slowly.dart';

void main() async {
  final sly = Slowly<String>();

  print('--- 1. Mutex Example (Mutual Exclusion) ---');
  // Mutex ensures that only one task for a given tag runs at a time.
  // Subsequent calls while the task is running are ignored.
  Future<void> longRunningTask(int id) async {
    final result = await sly.mutex('upload', () async {
      print('  [Task $id] Starting upload...');
      await Future.delayed(const Duration(milliseconds: 500));
      print('  [Task $id] Upload finished.');
      return 'Data from task $id';
    });

    if (result == null) {
      print('  [Task $id] Skipped (mutex locked)');
    } else {
      print('  [Task $id] Result: $result');
    }
  }

  // Fire off two tasks at once.
  longRunningTask(1);
  longRunningTask(2);

  await Future.delayed(const Duration(seconds: 1));

  print('\n--- 2. Debounce Example (Search-like behavior) ---');
  // Debounce waits for silence before executing the last call.
  // maxDuration ensures it eventually runs even if calls are frequent.
  void onSearchChanged(String query) {
    sly.debounce(
      'search',
      () {
        print('  Searching for: $query');
        return query;
      },
      duration: const Duration(milliseconds: 300),
      maxDuration: const Duration(seconds: 1),
    ).then((result) {
      if (result != null) {
        print('  Search result ready: $result');
      }
    });
  }

  print('  User typing: "f"... "fl"... "flu"... "flutt"... "flutter"');
  onSearchChanged('f');
  await Future.delayed(const Duration(milliseconds: 100));
  onSearchChanged('fl');
  await Future.delayed(const Duration(milliseconds: 100));
  onSearchChanged('flu');
  await Future.delayed(const Duration(milliseconds: 100));
  onSearchChanged('flutt');
  await Future.delayed(const Duration(milliseconds: 100));
  onSearchChanged('flutter');

  // Wait for debounce to trigger.
  await Future.delayed(const Duration(seconds: 1));

  print('\n--- 3. Throttle Example (Frequent event limit) ---');
  // Throttle runs immediately and then enters a cooling period.
  // ensureLast ensures the very last call is executed after the cooling period.
  void onButtonClick(int count) {
    sly.throttle(
      'click',
      () {
        print('  Button clicked (processed): $count');
      },
      duration: const Duration(milliseconds: 500),
      ensureLast: true,
    );
  }

  print('  User clicks button rapidly 5 times:');
  for (int i = 1; i <= 5; i++) {
    onButtonClick(i);
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // Wait for cooling period and ensureLast to trigger.
  await Future.delayed(const Duration(seconds: 1));

  print('\n--- Example Finished ---');
  sly.dispose();
}
