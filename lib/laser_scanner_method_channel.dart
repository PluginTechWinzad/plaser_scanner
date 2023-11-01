import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'laser_scanner_platform_interface.dart';

/// An implementation of [LaserScannerPlatform] that uses method channels.
class MethodChannelLaserScanner extends LaserScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('laser_scanner');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> openScanner() async {
    await methodChannel.invokeMethod<String>('openScanner');
  }

  @override
  Future<String?> onListenerResultScanner() async {
    await methodChannel.invokeMethod<String>('onListenerResultScanner');
  }

}
