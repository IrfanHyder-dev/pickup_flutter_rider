import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pickup/models/user_model.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/services/shared_preference.dart';
import 'package:pickup/src/app/apiErrorsMessage.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/bottom_bar/bottom_bar_view.dart';
import 'package:pickup/ui/views/bottom_bar/bottom_bar_viewmodel.dart';
import 'package:pickup/ui/views/profile/driver_profile/driver_profile_view.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel with CommonUiService {
  AuthService authService = locator<AuthService>();
  final ScrollController scrollController = ScrollController();
  TextEditingController emailPhoneCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  String email = '';
  String phoneNo = '';

  Future driverLogin() async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connection = await check();
    if (connection) {
      http.Response? response = await authService.loginDriver(
          email: email, phoneNo: phoneNo, password: passwordCon.text.trim());

      if (response?.statusCode == 200 && response != null) {
        var decodedResponse = jsonDecode(response.body);
        print('login response');
        debugPrint(response.body);
        if (decodedResponse['success']) {
          UserModel newModel = UserModel.fromJson(decodedResponse);
          StaticInfo.driverModel = newModel.data.driver;
          StaticInfo.vehicleModel = newModel.data.vehicle;
          StaticInfo.authToken = newModel.data.authToken;
          SharedPreferencesService().saveUser(newModel);
          Get.back();
          if (StaticInfo.driverModel!.isProfileCompleted) {
            locator<BottomBarViewModel>().newPageNo(2);
            Get.offAll(
              () => BottomBarView(index: 2),
            );
          } else {
            Get.offAll(() => const DriverProfileView());
          }
        } else {
          Get.back();
          showCustomErrorTextToast(
              context: Get.context!, text: decodedResponse['message']);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response?.statusCode);
      }
    } else {
      Get.back();
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
  }

  String? emailValidator(val) {
    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    RegExp phoneRegExp = RegExp(r'^\+923\d{9}$|^923\d{9}$|^03\d{9}$');
    if (emailExp.hasMatch(val.toString())) {
      email = emailPhoneCon.text.trim();
    } else if (phoneRegExp.hasMatch(val.toString())) {
      phoneNo = emailPhoneCon.text.trim();
    } else {
      return enterEmailOrMobRequireKey.tr;
    }
  }

  String? passwordValidator(val) {
    if (val.toString().isEmpty) {
      return passRequiredKey.tr;
    } else {
      return null;
    }
  }
}
