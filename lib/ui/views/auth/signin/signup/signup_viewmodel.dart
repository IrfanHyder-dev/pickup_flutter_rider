import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/models/user_model.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/services/shared_preference.dart';
import 'package:pickup/src/app/apiErrorsMessage.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/auth/otp/otp_view.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class SignUpViewModel extends BaseViewModel with CommonUiService {
  AuthService authService = locator<AuthService>();

  Future signUpParent({
    required name,
    required surName,
    required phoneNumber,
    required email,
    required password,
  }) async {
    bool connectivity = await check();
    if(connectivity){
      CustomDialog.showLoadingDialog(Get.context!);
      http.Response response = await authService.signUpDriver(
          name: name,
          surName: surName,
          phoneNumber: phoneNumber,
          email: email,
          password: password);
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        print('signup response');
        debugPrint(response.body);
        if (decodedResponse['success'] == true) {
          UserModel newModel = UserModel.fromJson(decodedResponse);
          StaticInfo.driverModel = newModel.data.driver;
          StaticInfo.authToken = newModel.data.authToken;
          SharedPreferencesService().saveUser(newModel);
          Get.back();
          Get.to(() => const OtpView());
        } else {
          Get.back();
          showCustomErrorTextToast(context: Get.context!, text: decodedResponse['errors'][0]);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    }else{
      Get.back();
      showCustomErrorTextToast(context: Get.context!, text: checkInternetKey.tr);
    }
  }

  String? nameValidator(val) {
    if (val.toString().isEmpty) {
      return nameRequiredKey.tr;
    } else {
      return null;
    }
  }

  String? surNameValidator(val) {
    if (val.toString().isEmpty) {
      return surnameRequiredKey.tr;
    } else {
      return null;
    }
  }

  String? phoneValidator(val) {
    RegExp regExp = RegExp(r'^(\03|3)\d{9}$');
    if (val.toString().isEmpty) {
      return mobNumbRequiredKey.tr;
    } else if (!regExp.hasMatch(val.toString())) {
      return validMobNumberKey.tr;
    } else {
      return null;
    }
  }

  String? emailValidator(val) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    if (val.toString().isEmpty) {
      return emailRequiredKey.tr;
    } else if (!regExp.hasMatch(val!)) {
      return validEmailKey.tr;
    } else {
      return null;
    }
  }

  String? passwordValidator(val) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (val.toString().isEmpty) {
      return passRequiredKey.tr;
    } else if (!regex.hasMatch(val.toString())) {
      return passInstructionKey.tr;
    } else {
      return null;
    }
  }
}
