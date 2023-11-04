import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first



class ResultScanIntentModel {
  int? length;
  String? barcode;
  String? bytesToHexString;
  String? barcodeStr;
  ResultScanIntentModel({
    this.length,
    this.barcode,
    this.bytesToHexString,
    this.barcodeStr,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'length': length,
      'barcode': barcode,
      'bytesToHexString': bytesToHexString,
      'barcodeStr': barcodeStr,
    };
  }

  factory ResultScanIntentModel.fromMap(Map<String, dynamic> map) {
    return ResultScanIntentModel(
      length: map['length'] != null ? map['length'] as int : 0,
      barcode: map['barcode'] != null ? map['barcode'] as String : null,
      bytesToHexString: map['bytesToHexString'] != null ? map['bytesToHexString'] as String : null,
      barcodeStr: map['barcodeStr'] != null ? map['barcodeStr'] as String : null,
    );
  }

  factory ResultScanIntentModel.fromMapScanResult(Map<Object?, Object?> map) {
    return ResultScanIntentModel(
      length: map['length'] != null ? map['length'] as int : 0,
      barcode: map['barcode'] != null ? map['barcode'] as String : null,
      bytesToHexString: map['bytesToHexString'] != null ? map['bytesToHexString'] as String : null,
      barcodeStr: map['barcodeStr'] != null ? map['barcodeStr'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResultScanIntentModel.fromJson(String source) => ResultScanIntentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
