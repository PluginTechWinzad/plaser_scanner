import 'dart:async';

import 'package:laser_scanner/model/scan_result_model.dart';
import 'package:laser_scanner/model/symbology_model.dart';
import 'package:laser_scanner/utils/enum_utils.dart';

import 'laser_scanner_platform_interface.dart';

class LaserScanner {
  /// Open the scanner.
  ///
  /// This method opens the laser scanner.
  /// [captureImageShowResult] Capture scanned images
  Future<void> openScanner({bool? captureImageShow = false}) async {
    LaserScannerPlatform.instance.openScanner(captureImageShow: captureImageShow);
  }

  /// Open the scanner.
  ///
  /// This method close the laser scanner.
  Future<void> closeScanner() async {
    LaserScannerPlatform.instance.closeScanner();
  }

  /// Listen for scan results.
  ///
  /// This method allows you to set up a listener to receive scan results.
  /// [onListenerResultScanner] is a callback function that receives a String? value.
  Future<StreamSubscription> onListenerScanner({required Function(ScanResultModel? value) onListenerResultScanner}) async {
    return await LaserScannerPlatform.instance.onListenerResultScanner(onListenerResultScanner: onListenerResultScanner);
  }

  /// Check if the scanner is turned on.
  ///
  /// This method checks whether the scanner is currently turned on.
  Future<void> isTurnOn() async {
    await LaserScannerPlatform.instance.isTurnOn();
  }

  /// Gets the output mode of the scanning process.
  ///
  /// Returns a Future with a [ScanOutputMode] enum value indicating the output mode.
  Future<ScanOutputMode> getScanOutputMode() async {
    final scanOutputMode = await LaserScannerPlatform.instance.getScanOutputMode();
    return scanOutputMode;
  }

  /// Sets the output mode for the scanning process.
  ///
  /// The [scanOutputMode] parameter is a [ScanOutputMode] enum value that specifies the desired output mode.
  Future<void> setScanOutputMode({required ScanOutputMode scanOutputMode}) async {
    await LaserScannerPlatform.instance.setScanOutputMode(
      scanOutputMode: scanOutputMode,
    );
  }

  /// Gets the state of the trigger lock mechanism.
  ///
  /// Returns a Future with a boolean indicating the state of the trigger lock mechanism.
  Future<bool?> getlockTriggerState() async {
    final scanOutputMode = await LaserScannerPlatform.instance.getlockTriggerState();
    return scanOutputMode;
  }

  /// Sets the state of the trigger lock mechanism.
  ///
  /// The [state] parameter is a boolean value that specifies whether to enable or disable the trigger lock.
  Future<void> setlockTriggerState({required bool state}) async {
    await LaserScannerPlatform.instance.setlockTriggerState(state: state);
  }

  /// Enables a specific barcode symbology.
  ///
  /// The [symbology] parameter is a [SymbologyModel] that defines the symbology to enable.
  ///
  /// Returns a Future with a boolean indicating the success of enabling the symbology.
  Future<bool> enableSymbology({required SymbologyModel symbology}) async {
    bool enableSymbology = await LaserScannerPlatform.instance.enableSymbology(symbology: symbology);
    return enableSymbology;
  }

  ///
  /// Sets the triggering mode for the scanner.
  ///
  /// The [triggering] parameter is a [Triggering] enum value that specifies the desired triggering mode.
  ///
  /// [Triggering.CONTINUOUS]
  /// scanning mode allows a scanner (such as a barcode scanner) to operate continuously without the need for a trigger button or user intervention. The scanner will automatically scan and read barcodes when it encounters them within its scanning range without being activated by the user. This mode is suitable when you want to scan multiple barcodes continuously without having to press the scan button each time.
  ///
  /// [Triggering.HOST]
  /// Host mode, also known as on-demand trigger mode, requires the user to press the scan button (trigger) on the scanner when they want to scan a specific barcode. The scanner does not scan automatically and requires user intervention to activate the scanning process. This mode is often used when you want precise control over when to scan barcodes and to avoid unnecessary scans.
  ///
  /// [Triggering.PULSE]
  /// Pulse mode is a combination of continuous scanning mode and trigger mode. In this mode, the scanner scans continuously, but it only reads barcodes when the user presses the scan button (trigger) once. After the user activates the trigger, the scanner scans and reads barcodes within its range. Pulse mode allows users to control the timing of barcode scanning while still benefiting from continuous scanning when barcodes are within the scanner's range.
  ///
  Future<void> setTrigger({required Triggering triggering}) async {
    await LaserScannerPlatform.instance.setTrigger(triggering: triggering);
  }

  /// Gets the current triggering mode of the scanner.
  ///
  /// Returns a Future with a [Triggering] enum value indicating the current triggering mode.
  Future<Triggering?> getTriggerMode() async {
    Triggering? triggerMode = await LaserScannerPlatform.instance.getTriggerMode();

    return triggerMode;
  }

  /// Turns off vibration.
  Future<void> unVibrate() async {
    await LaserScannerPlatform.instance.unVibrate();
  }

  /// Enables vibration.
  Future<void> enableVibrate() async {
    await LaserScannerPlatform.instance.enableVibrate();
  }

  /// start decode
  Future<void> startDecode() async {
    await LaserScannerPlatform.instance.startDecode();
  }

  /// stop decode
  Future<void> stopDecode() async {
    await LaserScannerPlatform.instance.stopDecode();
  }
}
