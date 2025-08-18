import 'dart:async';

typedef DebounceCallback = void Function();

class Debouncer {
  final Duration delay;
  Timer? _timer;
  DebounceCallback? _callback;

  Debouncer({required this.delay});

  void run(DebounceCallback callback) {
    _callback = callback;
    _timer?.cancel();
    _timer = Timer(delay, () {
      if (_callback != null) {
        _callback!();
        _callback = null;
      }
    });
  }

  void cancel() {
    _timer?.cancel();
    _callback = null;
  }
}
