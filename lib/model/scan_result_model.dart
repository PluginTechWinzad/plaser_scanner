import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ScanResultModel {
  int? length;
  String? barcode;
  String? bytesToHexString;
  String? barcodeStr;
  Uint8List? image;
  ScanResultModel({
    this.length,
    this.barcode,
    this.bytesToHexString,
    this.barcodeStr,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'length': length,
      'barcode': barcode,
      'bytesToHexString': bytesToHexString,
      'barcodeStr': barcodeStr,
      'image': image,
    };
  }

  factory ScanResultModel.fromMap(Map<String, dynamic> map) {
    return ScanResultModel(
      length: map['length'] != null ? map['length'] as int : 0,
      barcode: map['barcode'] != null ? map['barcode'] as String : null,
      bytesToHexString: map['bytesToHexString'] != null
          ? map['bytesToHexString'] as String
          : null,
      barcodeStr:
          map['barcodeStr'] != null ? map['barcodeStr'] as String : null,
      image: map['image'] != null ? Uint8List.fromList(map['image']) : null,
    );
  }

  factory ScanResultModel.fromMapScanResult(Map<Object?, Object?> map) {
    return ScanResultModel(
      length: map['length'] != null ? map['length'] as int : 0,
      barcode: map['barcode'] != null ? map['barcode'] as String : null,
      bytesToHexString: map['bytesToHexString'] != null
          ? map['bytesToHexString'] as String
          : null,
      barcodeStr:
          map['barcodeStr'] != null ? map['barcodeStr'] as String : null,
      image: map['image'] != null
          ? Uint8List.fromList(map['image'] as List<int>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScanResultModel.fromJson(String source) =>
      ScanResultModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
