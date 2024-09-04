import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/src/app/apiErrorsMessage.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class ResetPasswordViewModel extends BaseViewModel with CommonUiService{
  AuthService authService = locator<AuthService>();
  final ScrollController scrollController = ScrollController();
  TextEditingController emailCon = TextEditingController();

  Future resetPassword() async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connection = await check();
    if(connection){
      http.Response response =
          await authService.resetPassword(email: emailCon.text.trim());

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success'] == true) {
          emailCon.text = '';
          Get.back();
          showCustomSuccessTextToast(
              context: Get.context!, text: decodedResponse["message"]);
        } else {
          Get.back();
          showCustomErrorTextToast(
              context: Get.context!, text: decodedResponse["message"]);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    }else{
      Get.back();
      showCustomWarningTextToast(context: Get.context!, text: checkInternetKey.tr);
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
}