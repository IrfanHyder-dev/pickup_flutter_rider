import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:pickup/models/history_model.dart';
import 'package:pickup/models/payment_history_model.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/services/history_service.dart';
import 'package:pickup/src/app/apiErrorsMessage.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class HistoryViewModel extends BaseViewModel with CommonUiService {
  HistoryService historyService = locator<HistoryService>();
  double distanceCovered = 0.0;
  HistoryModel? rideHistory;
  PaymentHistoryModel? paymentHistory;
  bool isHistoryDataLoaded = false;
  bool isPaymentHistoryDataLoaded = false;

  initialise() {
    loadHistoriesData();
  }

  void loadHistoriesData()async{
    CustomDialog.showLoadingDialog(Get.context!);
    await driverRideHistory();
    await driverPaymentHistory();
    Get.back();
  }

  Future<void> driverRideHistory() async {
    bool connectivity = await check();
    if (connectivity) {
      try {
        http.Response response = await historyService.driverRideHistory();
        if (response.statusCode == 200) {
          var decodedResponse = json.decode(response.body);
          if (decodedResponse["success"]) {
            rideHistory = HistoryModel.fromJson(decodedResponse);
            for (var data in rideHistory!.data!) {
             double distanceCovered1 = await checkDistance(
                existingLat: double.parse(data.startLatitude ?? '0.0'),
                existingLng: double.parse(data.startLongitude ?? '0.0'),
                currentLat: double.parse(data.endLatitude ?? '0.0'),
                currentLng: double.parse(data.endLongitude ?? '0.0'),
              );
             data.distanceCovered = distanceCovered1 / 1000;
            }
            isHistoryDataLoaded = true;
          } else {
            Get.back();
            showCustomWarningTextToast(
                context: Get.context!, text: decodedResponse["message"]);
          }
        } else {
          ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
        }
      } on SocketException {
        showCustomWarningTextToast(
            context: Get.context!, text: "Socket Exception");
      } catch (e) {
      }
    } else {
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
    notifyListeners();
  }

  Future<void> driverPaymentHistory() async {
    bool connectivity = await check();
    if (connectivity) {
      try {
        http.Response response = await historyService.driverPaymentHistory();
        if (response.statusCode == 200) {
          var decodedResponse = json.decode(response.body);
          print('driver payment history  $decodedResponse');
          if (decodedResponse["success"]) {
            paymentHistory = PaymentHistoryModel.fromJson(decodedResponse);
            paymentHistory?.data?.sort((a,b)=> a.paymentDate!.compareTo(b.paymentDate!));
            print('driver payment history parent name ${paymentHistory?.data}');
            isPaymentHistoryDataLoaded = true;
          } else {
            Get.back();
            showCustomWarningTextToast(
                context: Get.context!, text: decodedResponse["message"]);
          }
        } else {
          ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
        }
      } on SocketException {
        showCustomWarningTextToast(
            context: Get.context!, text: "Socket Exception");
      } catch (e) {
      }
    } else {
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
    notifyListeners();
  }

  String extractMonthFromDate(String paymentDate){
    DateTime dateTime = DateFormat('EEEE, dd MMMM yyyy').parse(paymentDate);
    String month = DateFormat('MMMM').format(dateTime);
    print("Month: $month");
     return month;
  }

  Future<double> checkDistance({
    required double existingLat,
    required double existingLng,
    required double currentLat,
    required double currentLng,
  }) async {
    /// Create two Location objects for the coordinates
    final LocationData existingLocation = LocationData.fromMap({
      "latitude": existingLat,
      "longitude": existingLng,
    });
    final LocationData currentLocation = LocationData.fromMap({
      "latitude": currentLat,
      "longitude": currentLng,
    });

    /// Calculate the distance between the two points in meters
    final double distance = await Geolocator.distanceBetween(
      existingLocation.latitude!,
      existingLocation.longitude!,
      currentLocation.latitude!,
      currentLocation.longitude!,
    );
    debugPrint("existing location  ${existingLocation}");
    debugPrint("current location  ${currentLocation}");
    debugPrint("distance  ${distance}");
    distanceCovered = distance;
    return distance;
  }
}
