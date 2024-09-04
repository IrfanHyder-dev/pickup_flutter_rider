import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/services/profile_service.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';

class CurrentLocationViewModel extends BaseViewModel with CommonUiService {
  ProfileService profileService = locator<ProfileService>();
  String? address;

  initialize() {}

  Future<void> autoCompletePlaces({required LatLng latLng}) async {
    CustomDialog.showLoadingDialog(Get.context!);
    dynamic data = await profileService.getAddressFromLatLng(latLng: latLng);
    var response = json.decode(data.body);
    if (data.statusCode == 200) {
      if (response['status'] == 'OK') {
        var result = response['results'][0]['formatted_address'];
        print('address is $result');
        address = result;
        notifyListeners();
        Get.back();
        Get.back();
      } else {
        Get.back();
        showCustomErrorTextToast(
            context: Get.context!, text: googleMapErrKey.tr);
      }
    } else {
      Get.back();
      showCustomErrorTextToast(context: Get.context!, text: googleMapErrKey.tr);
    }
  }
}
