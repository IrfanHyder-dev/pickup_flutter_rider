// To parse this JSON data, do
//
//     final notificationSingleModel = notificationSingleModelFromJson(jsonString);

import 'dart:convert';

NotificationSingleModel notificationSingleModelFromJson(String str) => NotificationSingleModel.fromJson(json.decode(str));

String notificationSingleModelToJson(NotificationSingleModel data) => json.encode(data.toJson());

class NotificationSingleModel {
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
  dynamic userRole;
  NotificationDetail notificationDetail;

  NotificationSingleModel({
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

  factory NotificationSingleModel.fromJson(Map<String, dynamic> json) => NotificationSingleModel(
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
    notificationDetail: NotificationDetail.fromJson(json["notification_detail"]),
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

  factory NotificationDetail.fromJson(Map<String, dynamic> json) => NotificationDetail(
    createdDate: json["created_date"],
    createdTime: json["created_time"],
  );

  Map<String, dynamic> toJson() => {
    "created_date": createdDate,
    "created_time": createdTime,
  };
}
