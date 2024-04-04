import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unit_test_demo/app/weather_app.dart';

import 'app/core/utils/log_utils.dart';
import 'dependency_injection.dart';

void main() {
  /**
   * @function runZonedGuarded() is used to prevent uncaught exceptions from crashing the entire application
   */
  runZonedGuarded(() async {
    /**
     * Ensure that Flutter bindings are initialized before running the app.
     */
    WidgetsFlutterBinding.ensureInitialized();
    /**
     * For screen support portrait / landscape
     */
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    /**
     * Initial point of run app
     */
    initDI();
    runApp(const WeatherApp());
  }, (error, stack) {
    /**
     * Log error in DebugMode
     */
    LogUtils.printLogs(logs: 'An error occurred: - $error');
    LogUtils.printLogs(logs: 'Stack trace: - $stack');
  }, zoneSpecification: const ZoneSpecification());
}
