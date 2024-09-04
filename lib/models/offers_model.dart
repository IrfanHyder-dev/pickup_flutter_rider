// To parse this JSON data, do
//
//     final offersModel = offersModelFromJson(jsonString);

import 'dart:convert';

OffersModel offersModelFromJson(String str) => OffersModel.fromJson(json.decode(str));

String offersModelToJson(OffersModel data) => json.encode(data.toJson());

class OffersModel {
  bool success;
  String message;
  int status;
  List<Offers> data;

  OffersModel({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  factory OffersModel.fromJson(Map<String, dynamic> json) => OffersModel(
    success: json["success"],
    message: json["message"],
    status: json["status"],
    data: List<Offers>.from(json["data"].map((x) => Offers.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Offers {
  int id;
  double amount;
  String status;
  bool expired;
  int userId;
  int driverId;
  DateTime createdAt;
  DateTime updatedAt;
  String parentName;
  String parentImage;
  List<Child> children;
  bool isLocationSame;

  Offers({
    required this.id,
    required this.amount,
    required this.status,
    required this.expired,
    required this.userId,
    required this.driverId,
    required this.createdAt,
    required this.updatedAt,
    required this.parentName,
    required this.parentImage,
    required this.children,
    required this.isLocationSame,
  });

  factory Offers.fromJson(Map<String, dynamic> json) => Offers(
    id: json["id"],
    amount: json["amount"],
    status: json["status"],
    expired: json["expired"],
    userId: json["user_id"],
    driverId: json["driver_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    parentName: json["parent_name"],
    parentImage: json["parent_image"],
    isLocationSame: json["is_location_same"],
    children: List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "status": status,
    "expired": expired,
    "user_id": userId,
    "driver_id": driverId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "parent_name": parentName,
    "parent_image": parentImage,
    "is_location_same": isLocationSame,
    "children": List<dynamic>.from(children.map((x) => x.toJson())),
  };
}

class Child {
  int id;
  String name;
  int userId;
  String schoolName;
  DropOff pickUp;
  DropOff dropOff;
  DateTime start;
  DateTime end;

  Child({
    required this.id,
    required this.name,
    required this.userId,
    required this.schoolName,
    required this.pickUp,
    required this.dropOff,
    required this.start,
    required this.end,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    id: json["id"],
    name: json["name"],
    userId: json["user_id"],
    schoolName: json["school_name"],
    pickUp: DropOff.fromJson(json["pick_up"]),
    dropOff: DropOff.fromJson(json["drop_off"]),
    start: DateTime.parse(json["start"]),
    end: DateTime.parse(json["end"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "user_id": userId,
    "school_name": schoolName,
    "pick_up": pickUp.toJson(),
    "drop_off": dropOff.toJson(),
    "start": start.toIso8601String(),
    "end": end.toIso8601String(),
  };
}

class DropOff {
  double lat;
  double long;
  String address;

  DropOff({
    required this.lat,
    required this.long,
    required this.address,
  });

  factory DropOff.fromJson(Map<String, dynamic> json) => DropOff(
    lat: double.parse(json["lat"]),
    long: double.parse(json["long"]),
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "long": long,
    "address": address,
  };
}