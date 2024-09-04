// To parse this JSON data, do
//
//     final offerStatusModel = offerStatusModelFromJson(jsonString);

import 'dart:convert';

OfferStatusModel offerStatusModelFromJson(String str) => OfferStatusModel.fromJson(json.decode(str));

String offerStatusModelToJson(OfferStatusModel data) => json.encode(data.toJson());

class OfferStatusModel {
  bool success;
  String message;
  int status;
  Data data;

  OfferStatusModel({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  factory OfferStatusModel.fromJson(Map<String, dynamic> json) => OfferStatusModel(
    success: json["success"],
    message: json["message"],
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  String status;
  int id;
  double amount;
  bool expired;
  int userId;
  int driverId;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.status,
    required this.id,
    required this.amount,
    required this.expired,
    required this.userId,
    required this.driverId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    id: json["id"],
    amount: json["amount"]?.toDouble(),
    expired: json["expired"],
    userId: json["user_id"],
    driverId: json["driver_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "id": id,
    "amount": amount,
    "expired": expired,
    "user_id": userId,
    "driver_id": driverId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
