import 'package:laser_scanner/model/result_scan_intent_model.dart';

import 'laser_scanner_platform_interface.dart';

class LaserScanner {
  Future<String?> getPlatformVersion() {
    return LaserScannerPlatform.instance.getPlatformVersion();
  }

  /// Open the scanner.
  ///
  /// This method opens the laser scanner.
  Future<void> openScanner() async {
    LaserScannerPlatform.instance.openScanner();
  }

  /// Listen for scan results.
  ///
  /// This method allows you to set up a listener to receive scan results.
  /// [onListenerResultScanner] is a callback function that receives a String? value.
  Future<void> onListenerScanner({required Function(ResultScanIntentModel? value) onListenerResultScanner}) async {
    await LaserScannerPlatform.instance.onListenerResultScanner(onListenerResultScanner: onListenerResultScanner);
  }

  /// Check if the scanner is turned on.
  ///
  /// This method checks whether the scanner is currently turned on.
  Future<void> isTurnOn() async {
    await LaserScannerPlatform.instance.isTurnOn();
  }
}
