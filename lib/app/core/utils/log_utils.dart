import 'dart:developer';

import 'package:flutter/foundation.dart';

class LogUtils {
  LogUtils._();

  static printLogs({required String logs}) {
    if (kDebugMode) {
      log(logs);
    }
  }
}
