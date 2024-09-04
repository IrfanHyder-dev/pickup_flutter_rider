// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  bool success;
  String message;
  int status;

  // List<String>? errors;
  List<Notifications>? data;

  NotificationModel({
    required this.success,
    required this.message,
    required this.status,
    // this.errors,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        success: json["success"],
        message: json["message"],
        status: json["status"],
        // errors: json['errors'],
        data: json["data"] == null
            ? null
            : List<Notifications>.from(
            json["data"].map((x) => Notifications.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Notifications {
  int id;
  String? title;
  String? body;
  bool isRead;
  bool stopNotification;
  int? userId;
  DateTime createdAt;
  DateTime updatedAt;
  int? driverId;
  String? status;
  String? userRole;
  NotificationDetail notificationDetail;

  Notifications({
    required this.id,
    this.title,
    this.body,
    required this.isRead,
    required this.stopNotification,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.driverId,
    this.status,
    this.userRole,
    required this.notificationDetail,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    id: json["id"],
    title: json["title"],
    body: json["body"],
    isRead: json["is_read"],
    stopNotification: json["stop_notification"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    driverId: json["driver_id"],
    status: json["status"],
    userRole: json["user_role"],
    notificationDetail:
    NotificationDetail.fromJson(json["notification_detail"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    "is_read": isRead,
    "stop_notification": stopNotification,
    "user_id": userId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "driver_id": driverId,
    "status": status,
    "user_role": userRole,
    "notification_detail": notificationDetail.toJson(),
  };
}

class NotificationDetail {
  String createdDate;
  String createdTime;

  NotificationDetail({
    required this.createdDate,
    required this.createdTime,
  });

  factory NotificationDetail.fromJson(Map<String, dynamic> json) =>
      NotificationDetail(
        createdDate: json["created_date"],
        createdTime: json["created_time"],
      );

  Map<String, dynamic> toJson() => {
    "created_date": createdDate,
    "created_time": createdTime,
  };
}
