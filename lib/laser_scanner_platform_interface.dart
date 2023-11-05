import 'package:laser_scanner/model/scan_result_model.dart';
import 'package:laser_scanner/model/symbology_model.dart';
import 'package:laser_scanner/utils/enum_utils.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'laser_scanner_method_channel.dart';

abstract class LaserScannerPlatform extends PlatformInterface {
  /// Constructs a LaserScannerPlatform.
  LaserScannerPlatform() : super(token: _token);

  static final Object _token = Object();

  static LaserScannerPlatform _instance = MethodChannelLaserScanner();

  /// The default instance of [LaserScannerPlatform] to use.
  ///
  /// Defaults to [MethodChannelLaserScanner].
  static LaserScannerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LaserScannerPlatform] when
  /// they register themselves.
  static set instance(LaserScannerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> openScanner({bool? captureImageShow = false}) {
    throw UnimplementedError('openScanner() has not been implemented.');
  }

  Future<bool> closeScanner() {
    throw UnimplementedError('openScanner() has not been implemented.');
  }

  Future<void> onListenerResultScanner({required Function(ScanResultModel? value) onListenerResultScanner}) {
    throw UnimplementedError('onListenerResultScanner() has not been implemented.');
  }

  Future<bool> isTurnOn() {
    throw UnimplementedError('onListenerResultScanner() has not been implemented.');
  }

  Future<ScanOutputMode> getScanOutputMode() {
    throw UnimplementedError('getScanOutputMode() has not been implemented.');
  }

  Future<void> setScanOutputMode({required ScanOutputMode scanOutputMode}) {
    throw UnimplementedError('setScanOutputMode() has not been implemented.');
  }

  Future<bool?> getlockTriggerState() {
    throw UnimplementedError('getlockTriggerState() has not been implemented.');
  }

  Future<void> setlockTriggerState({required bool state}) {
    throw UnimplementedError('setlockTriggerState() has not been implemented.');
  }

  Future<bool> enableSymbology({required SymbologyModel symbology}) {
    throw UnimplementedError('enableSymbology() has not been implemented.');
  }

  Future<void> setTrigger({required Triggering triggering}) {
    throw UnimplementedError('setTrigger() has not been implemented.');
  }

  Future<Triggering?> getTriggerMode() {
    throw UnimplementedError('getTriggerMode() has not been implemented.');
  }
  Future<void> unVibrate() {
    throw UnimplementedError('setUnVibrate() has not been implemented.');
  }
  Future<void> enableVibrate() {
    throw UnimplementedError('setVibrate() has not been implemented.');
  }
  Future<void> startDecode() {
    throw UnimplementedError('startDecode() has not been implemented.');
  }
  Future<void> stopDecode() {
    throw UnimplementedError('stopDecode() has not been implemented.');
  }
}
