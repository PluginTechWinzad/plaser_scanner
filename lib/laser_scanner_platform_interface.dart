import 'package:laser_scanner/model/result_scan_intent_model.dart';
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

  Future<void> openScanner() {
    throw UnimplementedError('openScanner() has not been implemented.');
  }
  
  Future<bool> closeScanner() {
    throw UnimplementedError('openScanner() has not been implemented.');
  }

  Future<void> onListenerResultScanner({required Function(ResultScanIntentModel? value ) onListenerResultScanner}) {
    throw UnimplementedError('onListenerResultScanner() has not been implemented.');
  }

  Future<bool> isTurnOn() {
    throw UnimplementedError('onListenerResultScanner() has not been implemented.');
  }

  // Future<dynamic> setScannerMethodCallHandler() {
  //   throw UnimplementedError('onListenerResultScanner() has not been implemented.');
  // }

}
