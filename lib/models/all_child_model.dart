// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

AllChildModel welcomeFromJson(String str) => AllChildModel.fromJson(json.decode(str));

String welcomeToJson(AllChildModel data) => json.encode(data.toJson());

class AllChildModel {
  bool success;
  String message;
  int status;
  List<Datum> data;

  AllChildModel({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  factory AllChildModel.fromJson(Map<String, dynamic> json) => AllChildModel(
    success: json["success"],
    message: json["message"],
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String name;
  DateTime startTime;
  DateTime endTime;
  int userId;
  String schoolName;
  DropOff pickUp;
  DropOff dropOff;

  Datum({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.userId,
    required this.schoolName,
    required this.pickUp,
    required this.dropOff,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    startTime: DateTime.parse(json["start_time"]),
    endTime: DateTime.parse(json["end_time"]),
    userId: json["user_id"],
    schoolName: json["school_name"],
    pickUp: DropOff.fromJson(json["pick_up"]),
    dropOff: DropOff.fromJson(json["drop_off"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String(),
    "user_id": userId,
    "school_name": schoolName,
    "pick_up": pickUp.toJson(),
    "drop_off": dropOff.toJson(),
  };
}

class DropOff {
  String lat;
  String long;
  String address;

  DropOff({
    required this.lat,
    required this.long,
    required this.address,
  });

  factory DropOff.fromJson(Map<String, dynamic> json) => DropOff(
    lat: json["lat"],
    long: json["long"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "long": long,
    "address": address,
  };
}
