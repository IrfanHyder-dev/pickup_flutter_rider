// To parse this JSON data, do
//
//     final vehicleModel = vehicleModelFromJson(jsonString);

import 'dart:convert';

VehicleModel vehicleModelFromJson(String str) => VehicleModel.fromJson(json.decode(str));

String vehicleModelToJson(VehicleModel data) => json.encode(data.toJson());

class VehicleModel {
  int? vehicleType;
  String? vehicleModelYear;
  int? vehicleSeats;
  String? vehicleModel;
  String? vehicleMake;
  String? vehicleNumberPlate;
  String? vehicleColor;
  DateTime? maintenanceDate;
  DateTime? availableFrom;
  DateTime? availableTill;
  List<Vehicle> vehicleDocuments;
  List<Vehicle> vehicleImages;

  VehicleModel({
     this.vehicleType,
     this.vehicleModelYear,
     this.vehicleSeats,
     this.vehicleModel,
     this.vehicleMake,
     this.vehicleNumberPlate,
     this.vehicleColor,
     this.maintenanceDate,
     this.availableFrom,
     this.availableTill,
    required this.vehicleDocuments,
    required this.vehicleImages,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
    vehicleType: json["vehicle_type"],
    vehicleModelYear: json["vehicle_model_year"],
    vehicleSeats: json["vehicle_seats"],
    vehicleModel: json["vehicle_model"],
    vehicleMake: json["vehicle_make"],
    vehicleNumberPlate: json["vehicle_number_plate"],
    vehicleColor: json["vehicle_color"],
    maintenanceDate:(json["maintenance_date"] != null)?DateTime.parse(json["maintenance_date"]): DateTime(0,0,0,0),
    availableFrom:(json["available_from"] != null)? DateTime.parse(json["available_from"]) : DateTime(0,0,0,0),
    availableTill:((json["available_till"])!= null)? DateTime.parse(json["available_till"]) : DateTime(0,0,0,0),
    vehicleDocuments: List<Vehicle>.from(json["vehicle_documents"].map((x) => Vehicle.fromJson(x))),
    vehicleImages: List<Vehicle>.from(json["vehicle_images"].map((x) => Vehicle.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "vehicle_type": vehicleType,
    "vehicle_model_year": vehicleModelYear,
    "vehicle_seats": vehicleSeats,
    "vehicle_model": vehicleModel,
    "vehicle_make": vehicleMake,
    "vehicle_number_plate": vehicleNumberPlate,
    "vehicle_color": vehicleColor,
    "maintenance_date": maintenanceDate!.toIso8601String(),
    "available_from": availableFrom!.toIso8601String(),
    "available_till": availableTill!.toIso8601String(),
    "vehicle_documents": List<dynamic>.from(vehicleDocuments.map((x) => x.toJson())),
    "vehicle_images": List<dynamic>.from(vehicleImages.map((x) => x.toJson())),
  };
}

class Vehicle {
  int id;
  String url;

  Vehicle({
    required this.id,
    required this.url,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json["id"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
  };
}
