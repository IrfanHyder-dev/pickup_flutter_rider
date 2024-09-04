// To parse this JSON data, do
//
//     final baseModel = baseModelFromJson(jsonString);

import 'dart:convert';

BaseModel baseModelFromJson(String str) => BaseModel.fromJson(json.decode(str));

String baseModelToJson(BaseModel data) => json.encode(data.toJson());

class BaseModel {
  bool? success;
  String? message;
  int? status;

  BaseModel({
     this.success,
     this.message,
     this.status,
  });

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
    success: json["success"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "status": status,
  };
}
