import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:pickup/models/prediction.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/language/language_keys.dart';

@injectable
class ProfileService with CommonUiService {
  String? driverAddress;
  String? driverLat;
  String? driverLng;
  String? driverName;
  String? driverSurName;
  String? driverPhoneNo;
  String? driverLicenseFrontImage;
  String? driverLicenseBackImage;
  String? driverCnicFrontImage;
  String? driverCnicBackImage;
  String? driverImagePath;
  String? cnicNumber;

  Future autocompletePlaces({required String address}) async {
    print('api hit');
    http.Response response = await http.get('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$address&components=country:PK&key=$googleMapKey'.toUri(),);
    print('response is ${response.body} =====  ${response.statusCode} ');
    return response;
  }

  Future getAddressFromLatLng({required LatLng latLng}) async {
    print('api hit');
    http.Response response = await http.get('https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$googleMapKey'.toUri(),);
    return response;
  }

  Future getLatLng(String placeId) async {
    try {
      http.Response response = await http.get(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleMapKey'
            .toUri(),
      );
      print('response is ${response.body}');
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body)['result'];
        final geometry = result['geometry'];
        return geometry['location'];
      } else {
        return null;
      }
    } catch (e) {
      Get.back();
      showCustomWarningTextToast(context: Get.context!, text: wentWrongkey.tr);
      e.debugPrint();
      return null;
    }
  }

  Future getVehicleTypes() async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
      'Content-Type': 'application/json'
    };
    http.Response response =
        await http.get('${baseUrl}vehicle_types'.toUri(), headers: headers);
    print('vehicle types are ${response.body}');
    return response;
  }

  Future deleteImage({
    required imageId,
  }) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
      'Content-Type': 'application/json'
    };
    print('id is $imageId');
    http.Response response = await http.delete(
        '${baseUrl}drivers/103/delete_attachment'.toUri(),
        headers: headers);
    print('delete iamge ${response.body}');
  }

  Future addVehicle({
    required List<String> carImage,
    required List<String> documentImage,
    required List<int> deleteCarImageIdList,
    required List<int> deleteDocumentImageIdList,
    required String modelTypeId,
    required String modelYear,
    required int numOfSeats,
    required String numberPlate,
    required String maintenanceData,
    required String startTime,
    required String endTime,
    required String address,
    required String vehicleMake,
    required String vehicleColor,
  }) async {
    print('vehicle add111111');
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
      'Content-Type': 'application/json'
    };
    int? userId = StaticInfo.driverModel!.id;
    List<http.MultipartFile> documentImageFiles = [];
    for (String file in documentImage) {
      var f = await http.MultipartFile.fromPath('documents[]', file);
      documentImageFiles.add(f);
    }
    List<http.MultipartFile> vehicleImageFiles = [];
    for (String file in carImage) {
      var f = await http.MultipartFile.fromPath('vehicle_pictures[]', file);
      vehicleImageFiles.add(f);
    }
    List<http.MultipartFile> deleteCarImages = [];
    for (String file in documentImage) {
      var f =
          await http.MultipartFile.fromPath('vehicle_delete_pictures[]', file);
      deleteCarImages.add(f);
    }
    List<http.MultipartFile> deleteDocumentImages = [];
    for (String file in documentImage) {
      var f =
          await http.MultipartFile.fromPath('document_delete_pictures[]', file);
      deleteDocumentImages.add(f);
    }

    var request = http.MultipartRequest(
      "PUT",
      '${baseUrl}drivers/$userId'.toUri(),
    );
    request.fields["name"] = driverName!;
    request.fields["location"] = address!;
    request.fields["lat"] = driverLat!;
    request.fields["long"] = driverLng!;
    request.fields["surname"] = driverSurName!;
    request.fields["alternative_contact_number"] = driverPhoneNo!;
    request.fields["vehicle_model_year"] = modelYear;
    request.fields["vehicle_seats"] = numOfSeats.toString();
    request.fields["maintenance_date"] = maintenanceData;
    request.fields["available_from"] = startTime;
    request.fields["available_till"] = endTime;
    request.fields["vehicle_number_plate"] = numberPlate;
    request.fields["vehicle_model"] = modelYear;
    request.fields["vehicle_color"] = '';
    request.fields["vehicle_type_id"] = modelTypeId;
    request.fields["vehicle_make"] = vehicleMake;
    request.fields["cnic_number"] = cnicNumber!;
    request.fields["vehicle_color"] = vehicleColor;
    request.files.addAll(documentImageFiles);
    request.files.addAll(vehicleImageFiles);
    if (driverImagePath!.isNotEmpty) {
      request.files.add(
          await http.MultipartFile.fromPath("profile_pic", driverImagePath!));
    }
    if (driverLicenseFrontImage!.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
          "license_front", driverLicenseFrontImage!));
    }
    if (driverLicenseBackImage!.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
          "license_back", driverLicenseBackImage!));
    }
    if (driverCnicFrontImage!.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
          "cnic_front", driverCnicFrontImage!));
    }
    if (driverCnicBackImage!.isNotEmpty) {
      request.files.add(
          await http.MultipartFile.fromPath("cnic_back", driverCnicBackImage!));
    }

    request.headers.addAll(headers);
    var response = await request.send();
    // var responseData = await response.stream.toBytes();
    // var responseString = String.fromCharCodes(responseData);
    //
    // var result = json.decode(responseString);
    //print('veh is ${result}');
    //print('use is ${result['data']['driver']}');

   return response;
  }
}
