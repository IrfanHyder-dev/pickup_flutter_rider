import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pickup/models/paid_services_detail_model.dart';
import 'package:pickup/services/booking_service.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/src/app/apiErrorsMessage.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class PaidServicesDetailViewModel extends BaseViewModel with CommonUiService {
  BookingService bookingService = locator<BookingService>();
  PaidServicesDetailModel? paidServicesDetailModel;
  ScrollController scrollController = ScrollController();
  bool isDataLoad = false;

  initialise() {
    getPaidServices();
  }

  Future getPaidServices() async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if (connectivity) {
      http.Response response = await bookingService.getPaidServices();
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success'] == true) {
          paidServicesDetailModel =
              PaidServicesDetailModel.fromJson(decodedResponse);
          paidServicesDetailModel?.data.removeWhere((element) => element.children.length <= 0);
          isDataLoad = true;
          rebuildUi();
          Get.back();
        } else {
          Get.back();
          showCustomErrorTextToast(
              context: Get.context!, text: decodedResponse['message']);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    } else {
      Get.back();
      showCustomErrorTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
  }
}
