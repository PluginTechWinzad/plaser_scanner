import 'package:flutter/material.dart';
import 'dart:async';
import 'package:laser_scanner/laser_scanner.dart';
import 'package:laser_scanner/model/scan_result_model.dart';
import 'package:laser_scanner/utils/enum_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _laserScannerPlugin = LaserScanner();
  ScanResultModel scanResultModel = ScanResultModel();

  @override
  void initState() {
    super.initState();
    _openScanner();
  }

  Future<void> _openScanner() async {
    await _laserScannerPlugin.openScanner(
      captureImageShow: true,
    );
    _setTrigger();
    _getTrigger();
    await onListenerScanner();
  }

  Future<void> onListenerScanner() async {
    await _laserScannerPlugin.onListenerScanner(onListenerResultScanner: (value) {
      setState(() {
        scanResultModel = value ?? ScanResultModel();
      });
      _laserScannerPlugin.stopDecode();
    });
  }

  void _setTrigger() {
    _laserScannerPlugin.setTrigger(triggering: Triggering.HOST);
  }

  void _getTrigger() async {
    await _laserScannerPlugin.getTriggerMode();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Laser scanner'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('barcode: ${scanResultModel.barcode}'),
              const SizedBox(
                height: 10,
              ),
              Text('barcodeStr: ${scanResultModel.barcodeStr}'),
              const SizedBox(
                height: 10,
              ),
              Text('bytesToHexString: ${scanResultModel.bytesToHexString}'),
              const SizedBox(
                height: 10,
              ),
              Text('length: ${scanResultModel.length}'),
              const SizedBox(
                height: 100,
              ),
              if (scanResultModel.image != null)
                SizedBox(
                    height: 200, width: MediaQuery.of(context).size.width, child: Image.memory(scanResultModel.image!)),
              const SizedBox(
                height: 100,
              ),
              MaterialButton(
                onPressed: () {
                  _laserScannerPlugin.startDecode();
                },
                child: const Text("Scan"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
