import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickup/models/routes_response_model.dart';
import 'package:pickup/src/app/enums/app_enums.dart';

class UserFirebaseModel {
  GeoPoint? location;
  double? heading;
  RoutesModel? eveningShift;
  RoutesModel? morningShift;

  UserFirebaseModel({
    required this.location,
    required this.heading,
    required this.eveningShift,
    required this.morningShift,
  });

  UserFirebaseModel.fromJson(dynamic json) {
    location = json['location'];
    heading = json['heading'];
    eveningShift = json["evening_shift"] != "null"
        ? RoutesModel.fromJson(jsonDecode(json["evening_shift"]))
        : null;
    morningShift = json["morning_shift"] != "null"
        ? RoutesModel.fromJson(jsonDecode(json["morning_shift"]))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location;
    data['heading'] = this.heading;
    data["evening_shift"] = jsonEncode(this.eveningShift?.toJson());
    data["morning_shift"] = jsonEncode(this.morningShift?.toJson());
    return data;
  }
}

class RideStatusModel {
  Timestamp? rideDate;
  List<ChildList>? childList;
  String? driverFirebaseId;
  RideStatus? morningRideStatus;
  RideStatus? eveningRideStatus;
  String? rideStatusId;

  RideStatusModel(
      {this.rideDate,
      this.childList,
      this.driverFirebaseId,
      this.morningRideStatus,
      this.eveningRideStatus,
      this.rideStatusId});

  RideStatusModel.fromJson(dynamic json) {
    rideDate = json['ride_date'];

    if (json['child_list'] != null) {
      childList = <ChildList>[];
      json['child_list'].forEach((v) {
        childList!.add(new ChildList.fromJson(v));
      });
    }
    driverFirebaseId = json['driver_firebase_id'];
    if (json['morning_ride_status'] != null) {
      if (json['morning_ride_status'] == RideStatus.started.name) {
        morningRideStatus = RideStatus.started;
      } else if (json['morning_ride_status'] == RideStatus.not_started.name) {
        morningRideStatus = RideStatus.not_started;
      } else if (json['morning_ride_status'] == RideStatus.finished.name) {
        morningRideStatus = RideStatus.finished;
      } else {
        morningRideStatus = RideStatus.not_started;
      }
    } else {
      morningRideStatus = RideStatus.not_started;
    }
    if (json['evening_ride_status'] != null) {
      if (json['evening_ride_status'] == RideStatus.started.name) {
        eveningRideStatus = RideStatus.started;
      } else if (json['evening_ride_status'] == RideStatus.not_started.name) {
        eveningRideStatus = RideStatus.not_started;
      } else if (json['evening_ride_status'] == RideStatus.finished.name) {
        eveningRideStatus = RideStatus.finished;
      } else {
        eveningRideStatus = RideStatus.not_started;
      }
    } else {
      eveningRideStatus = RideStatus.not_started;
    }
    rideStatusId = json['ride_status_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ride_date'] = this.rideDate;
    if (this.childList != null) {
      data['child_list'] = this.childList!.map((v) => v.toJson()).toList();
    }
    data['driver_firebase_id'] = this.driverFirebaseId;
    data['morning_ride_status'] = this.morningRideStatus?.name;
    data['evening_ride_status'] = this.eveningRideStatus?.name;
    data['ride_status_id'] = this.rideStatusId;

    return data;
  }
}

class ChildList {
  Timestamp? arrivalTime;
  ArrivalStatus? arrivalStatus;
  int? id;
  int? reamingTimerTimeInSeconds;

  ChildList({
    this.arrivalTime,
    this.arrivalStatus,
    this.id,
    this.reamingTimerTimeInSeconds,
  });

  ChildList.fromJson(Map<String, dynamic> json) {
    arrivalTime = json['arrival_time'];
    reamingTimerTimeInSeconds = json['reaming_timer_time_in_seconds'];
    if (json['arrival_status'] == ArrivalStatus.arrival_soon.name) {
      arrivalStatus = ArrivalStatus.arrival_soon;
    }
    else if (json['arrival_status'] == ArrivalStatus.picked.name) {
      arrivalStatus = ArrivalStatus.picked;
    }
    else if (json['arrival_status'] == ArrivalStatus.dropped.name) {
      arrivalStatus = ArrivalStatus.dropped;
    }
    else if (json['arrival_status'] == ArrivalStatus.arrived.name) {
      arrivalStatus = ArrivalStatus.arrived;
    }
    else if (json['arrival_status'] == ArrivalStatus.not_going.name) {
      arrivalStatus = ArrivalStatus.not_going;
    }else {
      arrivalStatus = ArrivalStatus.not_arrived;
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['arrival_time'] = this.arrivalTime;
    data['arrival_status'] = this.arrivalStatus?.name;
    data['id'] = this.id;
    data['reaming_timer_time_in_seconds'] = this.reamingTimerTimeInSeconds;
    return data;
  }
}
