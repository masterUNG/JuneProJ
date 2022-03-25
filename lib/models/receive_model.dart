// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiveModel {
  final String carId;
  final String phone;
  final String province;
  final String status;
  final Timestamp timeService;
  ReceiveModel({
    required this.carId,
    required this.phone,
    required this.province,
    required this.status,
    required this.timeService,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'carId': carId,
      'phone': phone,
      'province': province,
      'status': status,
      'timeService': timeService,
    };
  }

  factory ReceiveModel.fromMap(Map<String, dynamic> map) {
    return ReceiveModel(
      carId: (map['carId'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      province: (map['province'] ?? '') as String,
      status: (map['status'] ?? '') as String,
      timeService: (map['timeService'] ),
    );
  }

  factory ReceiveModel.fromJson(String source) => ReceiveModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
