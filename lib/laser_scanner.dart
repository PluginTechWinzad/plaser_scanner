
import 'laser_scanner_platform_interface.dart';

class LaserScanner {
  Future<String?> getPlatformVersion() {
    return LaserScannerPlatform.instance.getPlatformVersion();
  }

  Future<void> openScanner() async {
    LaserScannerPlatform.instance.openScanner();
  }

  Future<void> onListen() async {
    LaserScannerPlatform.instance.openScanner();
  }

}
