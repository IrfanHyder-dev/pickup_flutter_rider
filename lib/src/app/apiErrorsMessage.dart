import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/src/language/language_keys.dart';

class ApiErrorsMessage with CommonUiService{
  void showApiErrorsMessage(dynamic statusCode){
    if(statusCode == 404){
      Get.back();
      showCustomErrorTextToast(context: Get.context!, text: notFoundKey.tr);
    }else if(statusCode == 500){
      Get.back();
      showCustomErrorTextToast(context: Get.context!, text: internalServerKey.tr);
    }
    else {
      Get.back();
      showCustomErrorTextToast(context: Get.context!, text: wentWrongkey.tr);
    }
  }
}