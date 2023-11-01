import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laser_scanner/laser_scanner_method_channel.dart';

void main() {
  MethodChannelLaserScanner platform = MethodChannelLaserScanner();
  const MethodChannel channel = MethodChannel('laser_scanner');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
