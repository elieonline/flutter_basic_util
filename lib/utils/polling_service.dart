import 'dart:async';
import 'package:flutter/foundation.dart';

import 'loggers.dart';

class PollingService {
  final Duration interval;
  final Future<bool> Function() onPoll;
  final Duration maxDuration;
  final int maxRetries;
  final VoidCallback? onLimitReached;
  bool _isPolling = false;
  DateTime? _startTime;
  int _retryCount = 0;

  PollingService({
    required this.onPoll,
    this.interval = const Duration(seconds: 3),
    this.maxDuration = const Duration(minutes: 1),
    this.maxRetries = 5,
    this.onLimitReached,
  });

  /// Start polling
  void start() {
    if (_isPolling) return;
    _isPolling = true;
    _startTime = DateTime.now();
    _retryCount = 0;
    _pollLoop();
  }

  /// The asynchronous polling loop
  Future<void> _pollLoop() async {
    while (_isPolling) {
      // Check if max retries or max duration exceeded
      if (_retryCount >= maxRetries ||
          (_startTime != null && DateTime.now().difference(_startTime!) >= maxDuration)) {
        stop();
        onLimitReached?.call();
        return;
      }

      // Increment retry count
      _retryCount++;

      // Perform poll
      bool success = false;
      try {
        success = await onPoll();
      } catch (e) {
        debugLog('Polling error: $e');
      }

      if (success) {
        stop();
        return;
      }

      // Wait for the interval before next poll
      await Future.delayed(interval);
    }
  }

  /// Stop polling
  void stop() {
    _isPolling = false;
    _startTime = null;
    _retryCount = 0;
  }

  /// Check if currently polling
  bool get isPolling => _isPolling;

  /// Dispose resources
  void dispose() {
    stop();
  }
}
