import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:laser_scanner/constants/event_name.dart';
import 'package:laser_scanner/model/scan_result_model.dart';
import 'package:laser_scanner/model/symbology_model.dart';
import 'package:laser_scanner/utils/enum_utils.dart';

import 'laser_scanner_platform_interface.dart';

/// An implementation of [LaserScannerPlatform] that uses method channels.
class MethodChannelLaserScanner extends LaserScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('laser_scanner');

  /// Opens the barcode scanner for scanning.
  ///captureImageShowcaptureImageShow
  /// Returns a Future that completes when the scanner is opened.
  @override
  Future<void> openScanner({bool? captureImageShow = false}) async {
    await methodChannel.invokeMethod<String>('openScanner',captureImageShow);
  }

  /// Closes the barcode scanner and returns the closing status.
  ///
  /// Returns a Future with a boolean indicating the status of the closing operation.
  @override
  Future<bool> closeScanner() async {
    final status = await methodChannel.invokeMethod<bool>('closeScanner');
    return status ?? false;
  }

  /// Sets up a listener to receive scanning results.
  ///
  /// The [onListenerResultScanner] parameter is a callback function that will be called with
  /// the scanning result when a scan is performed.
  @override
  Future<void> onListenerResultScanner({required onListenerResultScanner}) async {
    await methodChannel.invokeMethod<String>('onListenerResultScanner');
    _eventChanelScanner(onListenerResultScanner: onListenerResultScanner);
  }

  /// Checks if the scanner is currently turned on.
  ///
  /// Returns a Future with a boolean indicating whether the scanner is turned on.
  @override
  Future<bool> isTurnOn() async {
    final isTurnOn = await methodChannel.invokeMethod<bool>('isTurnOn');
    return isTurnOn == true;
  }

  /// Listens for events from the scanner channel and calls the [onListenerResultScanner] function.
  ///
  /// The [onListenerResultScanner] parameter is a callback function that will be called with
  /// the scanning result when a scan is performed.
  void _eventChanelScanner({required onListenerResultScanner}) {
    const eventChannel = EventChannel(SCANNER_RESULT);
    eventChannel.receiveBroadcastStream().listen((event) {
      final ScanResultModel resultScanIntentModel = ScanResultModel.fromMapScanResult(event);
      onListenerResultScanner(resultScanIntentModel);
    });
  }

  /// Gets the output mode of the scanning process.
  ///
  /// Returns a Future with a [ScanOutputMode] enum value indicating the output mode.
  @override
  Future<ScanOutputMode> getScanOutputMode() async {
    final scanOutputMode = await methodChannel.invokeMethod<int>('getScanOutputMode');
    return ScanOutputMode.values[scanOutputMode ?? 0];
  }

  /// Sets the output mode for the scanning process.
  ///
  /// The [scanOutputMode] parameter is a [ScanOutputMode] enum value that specifies the desired output mode.
  @override
  Future<void> setScanOutputMode({required ScanOutputMode scanOutputMode}) async {
    await methodChannel.invokeMethod(
      'setScanOutputMode',
      scanOutputModeValues[scanOutputMode],
    );
  }

  /// Gets the state of the trigger lock mechanism.
  ///
  /// Returns a Future with a boolean indicating the state of the trigger lock mechanism.
  @override
  Future<bool?> getlockTriggerState() async {
    final scanOutputMode = await methodChannel.invokeMethod<bool>('getlockTriggerState');
    return scanOutputMode;
  }

  /// Sets the state of the trigger lock mechanism.
  ///
  /// The [state] parameter is a boolean value that specifies whether to enable or disable the trigger lock.
  @override
  Future<void> setlockTriggerState({required bool state}) async {
    await methodChannel.invokeMethod('setlockTriggerState', state);
  }

  /// Enables a specific barcode symbology.
  ///
  /// The [symbology] parameter is a [SymbologyModel] that defines the symbology to enable.
  ///
  /// Returns a Future with a boolean indicating the success of enabling the symbology.
  @override
  Future<bool> enableSymbology({required SymbologyModel symbology}) async {
    bool enableSymbology = await methodChannel.invokeMethod('enableSymbology', symbology.toMap());
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
  @override
  Future<void> setTrigger({required Triggering triggering}) async {
    await methodChannel.invokeMethod('setTrigger', triggeringValues[triggering]);
  }

  /// Gets the current triggering mode of the scanner.
  ///
  /// Returns a Future with a [Triggering] enum value indicating the current triggering mode.
  @override
  Future<Triggering?> getTriggerMode() async {
    int trigger = await methodChannel.invokeMethod('getTriggerMode');
    return triggeringValuesFromInt[trigger];
  }

  /// Turns off vibration.
  @override
  Future<void> unVibrate() async {
    await methodChannel.invokeMethod('setUnVibrate');
  }

  /// Enables vibration.
  @override
  Future<void> enableVibrate() async {
    await methodChannel.invokeMethod('setVibrate');
  }

  /// start decode
  @override
  Future<void> startDecode() async {
    await methodChannel.invokeMethod('startDecode');
  }

  /// stop decode
  @override
  Future<void> stopDecode() async {
    await methodChannel.invokeMethod('stopDecode');
  }
}
