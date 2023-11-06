import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class SymbologyModel {
  final bool enable;
  final int symbology;
  SymbologyModel({
    required this.enable,
    required this.symbology,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'enable': enable,
      'symbology': symbology,
    };
  }

  factory SymbologyModel.fromMap(Map<String, dynamic> map) {
    return SymbologyModel(
      enable: map['enable'] as bool,
      symbology: map['symbology'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SymbologyModel.fromJson(String source) =>
      SymbologyModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
