# laser_scanner

# Laser Scanner Plugin

A Flutter plugin for integrating laser barcode and QR code scanning functionality into your Flutter app.

Urovo Android Smart POS Payment Terminal;Handheld Data Terminal, including the revision history.

## What It does?
- [x] Compile and deploy to your Urovo Android device (such as a Smart POS I9000S/I9100 model, PDA I6310/DT50/DT40/DT30 model).
- [x] Scanning barcodes and QR codes that contain images.

## Getting Started

Follow these steps to integrate the `laser_scanner` package into your Flutter project and start using it for barcode and QR code scanning.

### Installation

1. Add the `laser_scanner` package to your `pubspec.yaml` file:

   ```yaml
   dependencies:
     laser_scanner: ^latest_version


## Usage
Quick simple usage example:
#### Single file
```dart
final _laserScannerPlugin = LaserScanner();

await _laserScannerPlugin.openScanner(
      captureImageShow: true,
    );
    Future<void> onListenerScanner() async {
    await _laserScannerPlugin.onListenerScanner(onListenerResultScanner: (value) {
      setState(() {
        scanResultModel = value ?? ScanResultModel();
      });
      _laserScannerPlugin.stopDecode();
    });
  }
```
#### Set Trigger
[Triggering.CONTINUOUS] scanning mode allows a scanner (such as a barcode scanner) to operate continuously without the need for a trigger button or user intervention. The scanner will automatically scan and read barcodes when it encounters them within its scanning range without being activated by the user. This mode is suitable when you want to scan multiple barcodes continuously without having to press the scan button each time.

[Triggering.HOST] Host mode, also known as on-demand trigger mode, requires the user to press the scan button (trigger) on the scanner when they want to scan a specific barcode. The scanner does not scan automatically and requires user intervention to activate the scanning process. This mode is often used when you want precise control over when to scan barcodes and to avoid unnecessary scans.

[Triggering.PULSE] Pulse mode is a combination of continuous scanning mode and trigger mode. In this mode, the scanner scans continuously, but it only reads barcodes when the user presses the scan button (trigger) once. After the user activates the trigger, the scanner scans and reads barcodes within its range. Pulse mode allows users to control the timing of barcode scanning while still benefiting from continuous scanning when barcodes are within the scanner's range.
```dart
void _setTrigger() {
    _laserScannerPlugin.setTrigger(triggering: Triggering.HOST);
  }
```

## Example App
#### Android
![DemoAndroid]()