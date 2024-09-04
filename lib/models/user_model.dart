// To parse this JSON data, do
//
//     final newModel = newModelFromJson(jsonString);

import 'dart:convert';

UserModel newModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String newModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool success;
  String message;
  int status;
  Data data;

  UserModel({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
  String? authToken;
  dynamic fcmToken;
  bool mobileNotifications;
  bool emailNotifications;
  Driver driver;
  Vehicle vehicle;

  Data({
    this.authToken,
    required this.fcmToken,
    required this.mobileNotifications,
    required this.emailNotifications,
    required this.driver,
    required this.vehicle,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        authToken: json["auth_token"],
        fcmToken: json["fcm_token"],
        mobileNotifications: json["mobile_notifications"],
        emailNotifications: json["email_notifications"],
        driver: Driver.fromJson(json["driver"]),
        vehicle: Vehicle.fromJson(json["vehicle"]),
      );

  Map<String, dynamic> toJson() => {
        "auth_token": authToken,
        "fcm_token": fcmToken,
        "mobile_notifications": mobileNotifications,
        "email_notifications": emailNotifications,
        "driver": driver.toJson(),
        "vehicle": vehicle.toJson(),
      };
}

class Driver {
  int id;
  String? email;
  String? name;
  String? surname;
  String? contactNumber;
  String? alternativeContactNumber;
  String? cnicNumber;
  bool mobileNotifications;
  bool emailNotifications;
  bool isProfileVerified;
  bool isProfileCompleted;
  bool approvalStatus;
  DriverLocation driverLocation;
  String? driverDropOffLat;
  String? driverDropOffLong;
  String? driverDropOffLocation;
  String? profileImage;
  String? driverLicenseFront;
  String? driverLicenseBack;
  String? driverCnicFront;
  String? driverCnicBack;
  String driverFirebaseID;

  Driver({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.contactNumber,
    required this.alternativeContactNumber,
    required this.cnicNumber,
    required this.mobileNotifications,
    required this.emailNotifications,
    required this.isProfileVerified,
    required this.isProfileCompleted,
    required this.approvalStatus,
    required this.driverLocation,
    this.driverDropOffLat,
    this.driverDropOffLong,
    this.driverDropOffLocation,
    required this.profileImage,
    required this.driverLicenseFront,
    required this.driverLicenseBack,
    required this.driverCnicFront,
    required this.driverCnicBack,
    required this.driverFirebaseID,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        surname: json["surname"],
        contactNumber: json["contact_number"],
        alternativeContactNumber: json["alternative_contact_number"],
        cnicNumber: json["cnic_number"],
        mobileNotifications: json["mobile_notifications"],
        emailNotifications: json["email_notifications"],
        isProfileVerified: json["is_profile_verified"],
        isProfileCompleted: json["is_profile_completed"],
        approvalStatus: json["approval_status"],
        driverLocation: DriverLocation.fromJson(json["driver_location"]),
        driverDropOffLat: json["driver_drop_off_lat"],
        driverDropOffLong: json["driver_drop_off_long"],
        driverDropOffLocation: json["driver_drop_off_location"],
        profileImage: json["profile_image"],
        driverLicenseFront: json["driver_license_front"],
        driverLicenseBack: json["driver_license_back"],
        driverCnicFront: json["driver_cnic_front"],
        driverCnicBack: json["driver_cnic_back"],
        driverFirebaseID: json["driver_firebase_id"]??"",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "surname": surname,
        "contact_number": contactNumber,
        "alternative_contact_number": alternativeContactNumber,
        "cnic_number": cnicNumber,
        "mobile_notifications": mobileNotifications,
        "email_notifications": emailNotifications,
        "is_profile_verified": isProfileVerified,
        "is_profile_completed": isProfileCompleted,
        "approval_status": approvalStatus,
        "driver_location": driverLocation.toJson(),
        "driver_drop_off_lat": driverDropOffLat,
        "driver_drop_off_long": driverDropOffLong,
        "driver_drop_off_location": driverDropOffLocation,
        "profile_image": profileImage,
        "driver_license_front": driverLicenseFront,
        "driver_license_back": driverLicenseBack,
        "driver_cnic_front": driverCnicFront,
        "driver_cnic_back": driverCnicBack,
        "driver_firebase_id": driverFirebaseID,
      };
}

class DriverLocation {
  String? lat;
  String? long;
  String? address;

  DriverLocation({
    required this.lat,
    required this.long,
    required this.address,
  });

  factory DriverLocation.fromJson(Map<String, dynamic> json) => DriverLocation(
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

class Vehicle {
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
  List<VehicleImage> vehicleDocuments;
  List<VehicleImage> vehicleImages;

  Vehicle({
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

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        vehicleType: json["vehicle_type"],
        vehicleModelYear: json["vehicle_model_year"],
        vehicleSeats: json["vehicle_seats"],
        vehicleModel: json["vehicle_model"],
        vehicleMake: json["vehicle_make"],
        vehicleNumberPlate: json["vehicle_number_plate"],
        vehicleColor: json["vehicle_color"],
        maintenanceDate: (json["maintenance_date"] != null)
            ? DateTime.parse(json["maintenance_date"])
            : DateTime(0, 0, 0, 0),
        availableFrom: (json["available_from"] != null)
            ? DateTime.parse(json["available_from"])
            : DateTime(0, 0, 0, 0),
        availableTill: ((json["available_till"]) != null)
            ? DateTime.parse(json["available_till"])
            : DateTime(0, 0, 0, 0),
        //vehicleDocuments: List<VehicleImage>.from(json["vehicle_documents"].map((x) => x)),
        vehicleDocuments: List<VehicleImage>.from(
            json["vehicle_documents"].map((x) => VehicleImage.fromJson(x))),
        vehicleImages: List<VehicleImage>.from(
            json["vehicle_images"].map((x) => VehicleImage.fromJson(x))),
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
        "vehicle_documents": List<dynamic>.from(vehicleDocuments.map((x) => x)),
        "vehicle_images":
            List<dynamic>.from(vehicleImages.map((x) => x.toJson())),
      };
}

class VehicleImage {
  int id;
  String url;

  VehicleImage({
    required this.id,
    required this.url,
  });

  factory VehicleImage.fromJson(Map<String, dynamic> json) => VehicleImage(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}
