// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'dart:convert';

import 'package:pickup/src/app/enums/app_enums.dart';

HistoryModel historyModelFromJson(String str) =>
    HistoryModel.fromJson(json.decode(str));

String historyModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
  bool? success;
  String? message;
  int? status;
  List<HistoryData>? data;

  HistoryModel({
    this.success,
    this.message,
    this.status,
    this.data,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        success: json["success"],
        message: json["message"],
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<HistoryData>.from(
                json["data"]!.map((x) => HistoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class HistoryData {
  int? id;
  String? startLatitude;
  String? startLongitude;
  String? endLatitude;
  String? endLongitude;
  RideShiftType? shiftType;
  String? rideStartTime;
  String? rideEndTime;
  String? rideDate;
  double? distanceCovered;

  HistoryData({
    this.id,
    this.startLatitude,
    this.startLongitude,
    this.endLatitude,
    this.endLongitude,
    this.shiftType,
    this.rideStartTime,
    this.rideEndTime,
    this.rideDate,
    this.distanceCovered,
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) => HistoryData(
        id: json["id"],
    startLatitude: json["start_latitude"],
    startLongitude: json["start_longitude"],
    endLatitude: json["end_latitude"],
    endLongitude: json["end_longitude"],
        shiftType: (json["shift_type"] == RideShiftType.morning.name)
            ? RideShiftType.morning
            : (json["shift_type"] == RideShiftType.evening.name)
                ? RideShiftType.evening
                : RideShiftType.not_available,
        rideStartTime: json["ride_start_time"],
        rideEndTime: json["ride_end_time"],
        rideDate: json["ride_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
    "start_latitude": startLatitude,
    "start_longitude": startLongitude,
    "end_latitude": endLatitude,
    "end_longitude": endLongitude,
        "shift_type": shiftType,
        "ride_start_time": rideStartTime,
        "ride_end_time": rideEndTime,
        "ride_date": rideDate,
      };
}
