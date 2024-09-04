import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pickup/models/offer_status_model.dart';
import 'package:pickup/models/offers_model.dart';
import 'package:pickup/services/booking_service.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/src/app/apiErrorsMessage.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class MakeAnOfferViewModel extends BaseViewModel with CommonUiService {
  ScrollController scrollController = ScrollController();
  ScrollController childScrollController = ScrollController();
  BookingService bookingService = locator<BookingService>();
  OffersModel? offersModel;
  OfferStatusModel? offerStatusModel;
  List<Offers> offers = [];
  bool showSeeMoreText = false;
  int? outerListIndex;
  bool haveSameLocations = true;

  initialise() {
    fetchOffers();
  }

  Future fetchOffers() async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if (connectivity) {
      http.Response response = await bookingService.getBookings();
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success']) {
          offersModel = OffersModel.fromJson(decodedResponse);
          offers.addAll(offersModel!.data);
          offers.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          for (int i = 0; i < offers.length; i++) {
            if (offers[i].children.length > 1) {
              checkLocationsAreSame(offers[i].children, i);
            }
          }
          Get.back();
          notifyListeners();
        } else {
          Get.back();
          showCustomWarningTextToast(
              context: Get.context!, text: decodedResponse['message']);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    } else {
      Get.back();
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
  }

  Future<void> checkLocationsAreSame(List<Child> childList, int index) async {
    for (int i = 0; i < childList.length; i++) {
      double pickupDistance = await Geolocator.distanceBetween(
        childList[i].pickUp.lat,
        childList[i].pickUp.long,
        childList[i + 1].pickUp.lat,
        childList[i + 1].pickUp.long,
      );

      double dropOfDistance = await Geolocator.distanceBetween(
        childList[i].dropOff.lat,
        childList[i].dropOff.long,
        childList[i + 1].dropOff.lat,
        childList[i + 1].dropOff.long,
      );

      if (pickupDistance > 100 || dropOfDistance > 100) {
        haveSameLocations = false;
        offers[index].isLocationSame = false;
        break;
      }
    }
  }

  Future acceptOffer({required int offerId, required int index}) async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if (connectivity) {
      print('accept offer $offerId');
      http.Response response = await bookingService.acceptOrRejectOffer(
          offerId: offerId, status: 'accept');
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success'] == true) {
          if(decodedResponse['data'] != null){
            offerStatusModel = OfferStatusModel.fromJson(decodedResponse);
            //offersModel!.data[index].status = 'accept';
            offers[index].status = 'accept';
            notifyListeners();
            Get.back();
          }else{
            Get.back();
            showCustomWarningTextToast(
                context: Get.context!, text: decodedResponse['message']);
            offers.removeAt(index);
            notifyListeners();
          }
        } else {
          Get.back();
          showCustomWarningTextToast(
              context: Get.context!, text: decodedResponse['message']);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    } else {
      Get.back();
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
  }

  Future rejectOffer({required int offerId, required int index}) async {
    CustomDialog.showLoadingDialog(Get.context!);
    bool connectivity = await check();
    if (connectivity) {
      http.Response response = await bookingService.acceptOrRejectOffer(
          offerId: offerId, status: 'reject');
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success'] == true) {
          if(decodedResponse['data'] != null){
            offers.removeAt(index);
            notifyListeners();
            Get.back();
          }else{
            Get.back();
            showCustomWarningTextToast(
                context: Get.context!, text: decodedResponse['message']);
            offers.removeAt(index);
            notifyListeners();
          }
        } else {
          Get.back();
          showCustomWarningTextToast(
              context: Get.context!, text: decodedResponse['message']);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    } else {
      Get.back();
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
  }

  void seeMoreTextStatus(int index) {
    if (index == outerListIndex) {
      showSeeMoreText = !showSeeMoreText;
    } else {
      showSeeMoreText = true;
      outerListIndex = index;
    }
    notifyListeners();
  }
}
