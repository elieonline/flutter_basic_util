import 'dart:developer';

import 'package:flutter/foundation.dart';

debugLog(value) {
  if (kDebugMode) {
    log('[DEBUG] <======> $value');
  }
}
