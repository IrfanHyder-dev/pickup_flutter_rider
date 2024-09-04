import 'dart:convert';

import 'package:get/get.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/src/app/apiErrorsMessage.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/profile/driver_profile/driver_profile_view.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class OtpViewModel extends BaseViewModel with CommonUiService{
  AuthService authService = locator<AuthService>();

  Future otpVerification({
    required otpCode
}) async{
    CustomDialog.showLoadingDialog(Get.context!);
    bool connection = await check();
    if(connection){
      http.Response response =
          await authService.otpVerificationCode(otpCode: otpCode);
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success'] == true) {
          Get.back();
          Get.offAll(() => const DriverProfileView());
        } else {
          Get.back();
          showCustomErrorTextToast(
              context: Get.context!, text: decodedResponse['message']);
        }
      } else {
       ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    }else{
      Get.back();
      showCustomWarningTextToast(context: Get.context!, text: checkInternetKey.tr);
    }
  }
}