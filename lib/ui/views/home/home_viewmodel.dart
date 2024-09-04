import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickup/models/user_model.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/services/home_service.dart';
import 'package:pickup/services/shared_preference.dart';
import 'package:pickup/src/app/apiErrorsMessage.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/enums/app_enums.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/pick_drop_map/map_view/map_view.dart';
import 'package:pickup/ui/views/pick_drop_map/pick_drop_map_viewModel.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

@singleton
class HomeViewModel extends BaseViewModel
    with WidgetsBindingObserver, CommonUiService {
  HomeService homeService = locator<HomeService>();
  PickDropMapViewModel pickDropMapViewModel = PickDropMapViewModel();

  RideShiftType rideShiftType = RideShiftType.not_available;
  bool isQuotationsExist = false;
  late DateTime morningDropOffTime;

  late DateTime eveningDropOffTime;

  DateTime currentTime = DateTime.now();

  /// Define pickup time range
  DateTime? morningPickUpTime;

  /// Define drop off time range
  DateTime? eveningPickUpTime;

  initialise() async {
    WidgetsBinding.instance.addObserver(this);
    checkRideTime();
    getDriverDropOffLocation();
    print('auth token is ${StaticInfo.authToken}');
  }

  didChangeAppLifecycleState(AppLifecycleState state) async {
    if (AppLifecycleState.resumed == state) {
      if (!StaticInfo.driverModel!.approvalStatus) {
        checkDriverProfileStatus();
      }
    }
  }

  Future<void> moveToMapScreen({required BuildContext context}) async {
    /*--->>> In this function we are getting location permission <<<---*/
    bool isLocationGranted = await isLocationPermissionGranted();
    if (!isLocationGranted) {
      CustomDialog.showSettingDialog(
        context: context,
        infoText: goToSettingDialogTextKey.tr,
        headingText: 'Papne Driver ',
        showSecondBtn: true,
        secondBtnText: goToSettingBtnTextKey.tr,
        onTapBtn: () async {
          Get.back();
          await openAppSettings();
        },
      );
    } else {
      Get.to(() => PickDropMapView(
            rideShiftType: rideShiftType,
          ));
    }
  }

  Future<bool> isLocationPermissionGranted() async {
    bool isLocationGranted = false;

    var status = await Permission.locationAlways.status;
    debugPrint("check location when in App ${status}");
    if (!status.isGranted) {
      var status = await Permission.locationAlways.request();
      debugPrint("always status ${status}");
      if (status.isGranted) {
        isLocationGranted = true;
      }
    } else {
      isLocationGranted = true;
    }
    return isLocationGranted;
  }

  Future<void> checkDriverProfileStatus() async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if (connectivity) {
      http.Response response = await homeService.profileStatus();
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        if (decodedResponse['status'] == 200) {
          UserModel? newModel = SharedPreferencesService().getUser();
          StaticInfo.driverModel!.approvalStatus = true;
          newModel!.data.driver.approvalStatus = true;
          SharedPreferencesService().saveUser(newModel);
          notifyListeners();
          Get.back();
        } else {
          Get.back();
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    } else {
      showCustomErrorTextToast(
          context: Get.context!, text: checkInternetKey.tr);
      Get.back();
    }
  }

  profileApprovalStatus() async {
    StaticInfo.driverModel!.approvalStatus = true;
    notifyListeners();
  }

  Future<void> getDriverDropOffLocation() async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    await pickDropMapViewModel.fetchChildDetails();
    if(pickDropMapViewModel.childDetails?.fetchedChildList != null){
      isQuotationsExist =
          pickDropMapViewModel.childDetails!.fetchedChildList!.length > 0;
    }
    if (connectivity) {
      http.Response response = await homeService.getDriverDropOffLocation();
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        if (decodedResponse['status'] == 200) {
          UserModel? newModel = SharedPreferencesService().getUser();
          String dropOffLat = decodedResponse["data"]['drop_off_lat'] ?? "";
          String dropOffLng = decodedResponse["data"]['drop_off_long'] ?? "";
          String dropOffAddress =
              decodedResponse["data"]['drop_off_location'] ?? "";

          StaticInfo.driverModel!.driverDropOffLat = dropOffLat;
          StaticInfo.driverModel!.driverDropOffLong = dropOffLng;
          StaticInfo.driverModel!.driverDropOffLocation = dropOffAddress;
          newModel!.data.driver.driverDropOffLat = dropOffLat;
          newModel.data.driver.driverDropOffLong = dropOffLng;
          newModel.data.driver.driverDropOffLocation = dropOffAddress;
          SharedPreferencesService().saveUser(newModel);
          notifyListeners();
          Get.back();
        } else {
          Get.back();
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    } else {
      showCustomErrorTextToast(
          context: Get.context!, text: checkInternetKey.tr);
      Get.back();
    }
  }

  Future<void> getRideDateTime() async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if (connectivity) {
      http.Response response = await homeService.getRideDateTime();
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        if (decodedResponse['status'] == 200) {
          UserModel newModel = UserModel.fromJson(decodedResponse);
          StaticInfo.driverModel = newModel.data.driver;
          StaticInfo.vehicleModel = newModel.data.vehicle;
          StaticInfo.authToken = newModel.data.authToken;
          SharedPreferencesService().saveUser(newModel);
          checkRideTime();
          Get.back();
        } else {
          Get.back();
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    } else {
      showCustomErrorTextToast(
          context: Get.context!, text: checkInternetKey.tr);
      Get.back();
    }
  }

  void checkRideTime() {
    morningDropOffTime =
        DateTime.parse(StaticInfo.vehicleModel!.availableFrom.toString());
    eveningDropOffTime =
        DateTime.parse(StaticInfo.vehicleModel!.availableTill.toString());

    morningPickUpTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        morningDropOffTime.hour - 1,
        morningDropOffTime.minute,
        morningDropOffTime.second);

    eveningPickUpTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        eveningDropOffTime.hour - 1,
        eveningDropOffTime.minute,
        eveningDropOffTime.second);

    rideShiftType = RideShiftType.morning;

    // /// Check if the current time is within pickup time range
    // if (currentTime.isAfter(morningPickUpTime!) &&
    //     currentTime.isBefore(morningDropOffTime)) {
    //   print('morning Shift Time');
    //   rideShiftType = RideShiftType.morning;
    // } else if (currentTime.isAfter(eveningPickUpTime!) &&
    //     currentTime.isBefore(eveningDropOffTime)) {
    //   print('evening Shift Time');
    //   rideShiftType = RideShiftType.evening;
    // } else {
    //   rideShiftType = RideShiftType.not_available;
    //   print('time is over');
    // }
    notifyListeners();
  }

  String formatDuration(Duration duration) {
    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}';
  }

  bool isServiceTime() {
    return false;
  }
}
