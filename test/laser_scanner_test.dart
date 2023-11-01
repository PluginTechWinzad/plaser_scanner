import 'package:flutter_test/flutter_test.dart';
import 'package:laser_scanner/laser_scanner.dart';
import 'package:laser_scanner/laser_scanner_platform_interface.dart';
import 'package:laser_scanner/laser_scanner_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLaserScannerPlatform
    with MockPlatformInterfaceMixin
    implements LaserScannerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LaserScannerPlatform initialPlatform = LaserScannerPlatform.instance;

  test('$MethodChannelLaserScanner is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLaserScanner>());
  });

  test('getPlatformVersion', () async {
    LaserScanner laserScannerPlugin = LaserScanner();
    MockLaserScannerPlatform fakePlatform = MockLaserScannerPlatform();
    LaserScannerPlatform.instance = fakePlatform;

    expect(await laserScannerPlugin.getPlatformVersion(), '42');
  });
}
