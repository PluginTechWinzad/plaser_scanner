import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:laser_scanner/constants/event_name.dart';
import 'package:laser_scanner/model/result_scan_intent_model.dart';

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
  Future<bool> closeScanner() async {
    final status = await methodChannel.invokeMethod<bool>('closeScanner');
    return status ?? false;
  }

  @override
  Future<void> onListenerResultScanner({required onListenerResultScanner}) async {
    await methodChannel.invokeMethod<String>('onListenerResultScanner');
    _eventChanelScanner(onListenerResultScanner: onListenerResultScanner);
  }

  @override
  Future<bool> isTurnOn() async {
    final isTurnOn = await methodChannel.invokeMethod<bool>('isTurnOn');
    return isTurnOn == true;
  }

  // @override
  // Future<dynamic> setScannerMethodCallHandler() async {
  //   methodChannel.setMethodCallHandler(invokedMethods);
  //   return onListenerResultScanner;
  // }

  // Future<dynamic> invokedMethods(MethodCall methodCall) async {
  //   switch (methodCall.method) {
  //     case "openCaller":
  //   }
  // }

  void _eventChanelScanner({required onListenerResultScanner}) {
    const eventChannel = EventChannel(SCANNER_RESULT);
    eventChannel.receiveBroadcastStream().listen((event) {
      final ResultScanIntentModel resultScanIntentModel = ResultScanIntentModel.fromMapScanResult(event);
      onListenerResultScanner(resultScanIntentModel);
    });
  }
}
