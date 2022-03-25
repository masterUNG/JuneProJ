// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TimeServiceModel {
  final List<String> carService;
  final List<String> motoService;
  final Timestamp workDate;
  TimeServiceModel({
    required this.carService,
    required this.motoService,
    required this.workDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'carService': carService,
      'motoService': motoService,
      'workdate': workDate,
    };
  }

  factory TimeServiceModel.fromMap(Map<String, dynamic> map) {
    return TimeServiceModel(
      carService: List<String>.from((map['carService'] ?? const <String>[])),
      motoService: List<String>.from((map['motoService'] ?? const <String>[])),
      workDate: (map['workdate']),
    );
  }

  factory TimeServiceModel.fromJson(String source) => TimeServiceModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
