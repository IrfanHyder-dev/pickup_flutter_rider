// To parse this JSON data, do
//
//     final fetchChildDetails = fetchChildDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:pickup/src/app/enums/app_enums.dart';

FetchChildDetails fetchChildDetailsFromJson(String str) => FetchChildDetails.fromJson(json.decode(str));

String fetchChildDetailsToJson(FetchChildDetails data) => json.encode(data.toJson());

class FetchChildDetails {
  bool? success;
  String? message;
  int? status;
  List<FetchChildListModel>? fetchedChildList;

  FetchChildDetails({
    this.success,
    this.message,
    this.status,
    this.fetchedChildList,
  });

  factory FetchChildDetails.fromJson(Map<String, dynamic> json) => FetchChildDetails(
    success: json["success"],
    message: json["message"],
    status: json["status"],
    fetchedChildList: json["data"] == null ? [] : List<FetchChildListModel>.from(json["data"]!.map((x) => FetchChildListModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "status": status,
    "data": fetchedChildList == null ? [] : List<dynamic>.from(fetchedChildList!.map((x) => x.toJson())),
  };
}

class FetchChildListModel {
  int? id;
  ArrivalStatus? rideStatus;
  int? quotationId;
  Child? child;

  FetchChildListModel({
    this.id,
    this.rideStatus,
    this.quotationId,
    this.child,
  });

  factory FetchChildListModel.fromJson(Map<String, dynamic> json) => FetchChildListModel(
    id: json["id"],
    rideStatus: (json["ride_status"] == ArrivalStatus.picked.name)
  ? ArrivalStatus.picked
      : (json["ride_status"] == ArrivalStatus.arrived.name)
  ? ArrivalStatus.arrived
      : (json["ride_status"] == ArrivalStatus.dropped.name)
  ? ArrivalStatus.dropped
      : (json["ride_status"] == ArrivalStatus.not_going.name)
  ? ArrivalStatus.not_going
      : ArrivalStatus.not_arrived,
    quotationId: json["quotation_id"],
    child: json["child"] == null ? null : Child.fromJson(json["child"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ride_status": rideStatus,
    "quotation_id": quotationId,
    "child": child?.toJson(),
  };
}

class Child {
  int? id;
  String? name;
  String? pickUpLat;
  String? pickUpLong;
  String? pickUpLocation;
  String? dropOffLat;
  String? dropOffLong;
  String? dropOffLocation;
  String? schoolName;
  bool? isSelected;
  DateTime? start;
  DateTime? end;

  Child({
    this.id,
    this.name,
    this.pickUpLat,
    this.pickUpLong,
    this.pickUpLocation,
    this.dropOffLat,
    this.dropOffLong,
    this.dropOffLocation,
    this.schoolName,
    this.isSelected,
    this.start,
    this.end,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    id: json["id"],
    name: json["name"],
    pickUpLat: json["pick_up_lat"],
    pickUpLong: json["pick_up_long"],
    pickUpLocation: json["pick_up_location"],
    dropOffLat: json["drop_off_lat"],
    dropOffLong: json["drop_off_long"],
    dropOffLocation: json["drop_off_location"],
    schoolName: json["school_name"],
    isSelected: json["is_selected"],
    start: json["start"] == null ? null : DateTime.parse(json["start"]),
    end: json["end"] == null ? null : DateTime.parse(json["end"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "pick_up_lat": pickUpLat,
    "pick_up_long": pickUpLong,
    "pick_up_location": pickUpLocation,
    "drop_off_lat": dropOffLat,
    "drop_off_long": dropOffLong,
    "drop_off_location": dropOffLocation,
    "school_name": schoolName,
    "is_selected": isSelected,
    "start": start?.toIso8601String(),
    "end": end?.toIso8601String(),
  };
}

class ChangeChildStatus{
  int quotationId;
  int childId;

  ChangeChildStatus({
    required this.quotationId,
    required this.childId,
  });
}
