import 'dart:convert';

import 'package:get/get.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/services/notification_service.dart';
import 'package:pickup/src/app/apiErrorsMessage.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class SettingsViewModel extends BaseViewModel with CommonUiService{
  AuthService authService = locator<AuthService>();
  NotificationService notificationService = locator<NotificationService>();
  bool value = true;

  initialise() {
    value = StaticInfo.driverModel!.mobileNotifications;
  }
  Future logout() async{
    bool connection = await check();
    if(connection){
      authService.logout();
    }
    else{
      showCustomWarningTextToast(context: Get.context!, text: checkInternetKey.tr);
    }
  }
  void switchButtonOnChange(bool val) {
    value = val;
    stopNotification(status: val);
    rebuildUi();
  }
  Future<void> stopNotification({required bool status})async{

    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if(connectivity){
      http.Response response =
      await notificationService.stopNotification(status: status);
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success'] == true) {
          Get.back();
        } else {
          Get.back();
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    }else {
      Get.back();
      showCustomErrorTextToast(context: Get.context!, text: checkInternetKey.tr);
    }
  }
}