import 'dart:developer';

class NetworkLogUtils {
  NetworkLogUtils._();

  static printLogs({required String logs, required bool isDebugMode}) {
    if (isDebugMode) {
      log(logs);
    }
  }
}
