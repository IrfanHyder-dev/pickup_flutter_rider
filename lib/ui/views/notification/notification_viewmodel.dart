import 'dart:convert';

import 'package:get/get.dart';
import 'package:pickup/models/notification_model.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/services/notification_service.dart';
import 'package:pickup/src/app/apiErrorsMessage.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class NotificationViewModel extends BaseViewModel with CommonUiService {
  NotificationService notificationService = locator<NotificationService>();

  final List<Notifications> newNotificationList = [];
  final List<Notifications> earlierNotificationList = [];
  NotificationModel? notificationModel;
  bool isDataLoad = false;

  initialise() {
    fetchNotification();
  }

  Future<void> fetchNotification() async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if(connectivity){
      newNotificationList.clear();
      earlierNotificationList.clear();
      http.Response response =
      await notificationService.fetchNotifications();
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success'] == true) {
          //if (response.data != null) {
          notificationModel = NotificationModel.fromJson(decodedResponse);
          print('response is $notificationModel');
          filterNotifications();
          isDataLoad = true;
          rebuildUi();
          Get.back();
          //}
        } else {
          isDataLoad = true;
          rebuildUi();
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

  void filterNotifications() {
    for (final item in notificationModel!.data!) {
      print('date is ${item}');
      if (isToday(item.createdAt)) {
        print('to day date');
        newNotificationList.add(item);
        newNotificationList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        earlierNotificationList.add(item);
        earlierNotificationList
            .sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    }
  }

  bool isToday(DateTime date) {
    DateTime now = DateTime.now();
    // Compare the year, month, and day of the two dates
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return true;
    }

    return false;
  }

  Future<void> markNotificationRead(
      {required int id, required String listName, required int index}) async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if(connectivity){
      http.Response response =
      await notificationService.markNotificationRead(id: id);

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success'] == true) {
          if (listName == 'newList') {
            newNotificationList[index].isRead = true;
          } else {
            earlierNotificationList[index].isRead = true;
          }
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
    }else{
      Get.back();
      showCustomWarningTextToast(context: Get.context!, text: checkInternetKey.tr);
    }
  }

  Future<void> deleteNotification({
    required int id,
    required int index,
    required String listName,
  }) async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if(connectivity){
      http.Response response = await notificationService.deleteNotification(
          id: id);
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success'] == true) {
          if (listName == 'newList') {
            newNotificationList.removeAt(index);
          } else {
            earlierNotificationList.removeAt(index);
          }
          if (newNotificationList.isEmpty && earlierNotificationList.isEmpty) {
            notificationModel = null;
          }
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
    }else{
      Get.back();
      showCustomWarningTextToast(context: Get.context!, text: checkInternetKey.tr);
    }
  }
}
