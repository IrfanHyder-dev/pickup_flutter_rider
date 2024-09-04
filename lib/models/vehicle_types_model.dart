// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<VehicleTypesModel> welcomeFromJson(String str) => List<VehicleTypesModel>.from(json.decode(str).map((x) => VehicleTypesModel.fromJson(x)));

String welcomeToJson(List<VehicleTypesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehicleTypesModel {
  int id;
  String label;
  int minimumSeat;
  int maximumSeat;
  String vehicleIcon;

  VehicleTypesModel({
    required this.id,
    required this.label,
    required this.minimumSeat,
    required this.maximumSeat,
    required this.vehicleIcon,
  });

  factory VehicleTypesModel.fromJson(Map<String, dynamic> json) => VehicleTypesModel(
    id: json["id"],
    label: json["label"],
    minimumSeat: json["minimum_seat"],
    maximumSeat: json["maximum_seat"],
    vehicleIcon: json["vehicle_icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "minimum_seat": minimumSeat,
    "maximum_seat": maximumSeat,
    "vehicle_icon": vehicleIcon,
  };
}
