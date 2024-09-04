import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:pickup/models/prediction.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/services/profile_service.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/src/theme/base_theme.dart';
import 'package:pickup/ui/views/profile/vehicle_detail/vehicle_detail_view.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

@injectable
class DriverProfileViewModel extends BaseViewModel with CommonUiService {
  ProfileService profileService = locator<ProfileService>();

  File? profileImage = null;
  File? licenseFrontImage = null;
  File? licenseBackImage = null;
  File? cnicFrontImage = null;
  File? cnicBackImage = null;
  final ScrollController scrollController = ScrollController();
  ScrollController listViewCont = ScrollController();
  final ScrollController placeListCon = ScrollController();
  TextEditingController addressCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController surNameCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  TextEditingController cnicCon = TextEditingController();
  bool showSuggestion = false;
  Timer? _debounceTimer;
  bool imageValidationCheck = false;
  Color redColor = Colors.red;
  List<Prediction> suggestions = [];
  LatLng? driverLocLatLng;
  String? startingAddress;

  var maskFormatter = new MaskTextInputFormatter(
    mask: '#####-#######-#',
    //RegExp regex = new RegExp(r"^[0-9]{5}-[0-9]{7}-[0-9]{1}$");
    //filter: { "#": RegExp(r"^[0-9]{5}-[0-9]{7}-[0-9]{1}$") },
    type: MaskAutoCompletionType.lazy,
  );

  String driverLicenseFrontImageLink = '';
  String driverLicenseBackImageLink = '';
  String driverCnicFrontImageLink = '';
  String driverCnicBackImageLink = '';

  initialise() async {
    print('init');
    CustomDialog.showLoadingDialog(Get.context!);
    documentsImagesLinks();
    driverInitialInfo();
  }

  driverInitialInfo() {
    if (StaticInfo.driverModel!.name!.isNotEmpty) {
      nameCon.text = StaticInfo.driverModel!.name!;
      surNameCon.text = StaticInfo.driverModel!.surname!;
    }
    if (StaticInfo.driverModel!.alternativeContactNumber != null) {
      phoneCon.text = StaticInfo.driverModel!.alternativeContactNumber!;
    }
    if (StaticInfo.driverModel!.driverLocation.address != null) {
      addressCon.text = StaticInfo.driverModel!.driverLocation.address!;
    }
    if (StaticInfo.driverModel!.cnicNumber != null) {
      cnicCon.text = StaticInfo.driverModel!.cnicNumber!;
    }
  }

  void documentsImagesLinks() {
    if (StaticInfo.driverModel!.isProfileCompleted) {
      driverLicenseFrontImageLink = StaticInfo.driverModel!.driverLicenseFront!;
      driverLicenseBackImageLink = StaticInfo.driverModel!.driverLicenseBack!;
      driverCnicFrontImageLink = StaticInfo.driverModel!.driverCnicFront!;
      driverCnicBackImageLink = StaticInfo.driverModel!.driverCnicBack!;
    }

    print('doc images $driverLicenseFrontImageLink');
    rebuildUi();
    Get.back();
  }

  void debouncing({required Function() fn, int waitForMs = 1}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(seconds: waitForMs), fn);
  }

  Future<void> autoCompletePlaces({required String address}) async {
    http.Response response = await profileService.autocompletePlaces(address: address);
    if (response.statusCode == 200 && (jsonDecode(response.body)['status'] == "OK" || jsonDecode(response.body)['status'] == "ZERO_RESULTS")) {
      final predictions = jsonDecode(response.body)['predictions'] as List<dynamic>;
      var result =  predictions.map((prediction) => Prediction.fromJson(prediction)).toList();
      if (result != null) {
        suggestions.clear();
        for (final place in result) {
          suggestions.add(place);
        }
      }else{
        showCustomErrorTextToast(context: Get.context!, text: googleMapErrKey.tr);
      }
    } else {
      showCustomErrorTextToast(context: Get.context!, text: googleMapErrKey.tr);
    }

    rebuildUi();
  }

  Future<void> getLatLng(String placeId) async {
    CustomDialog.showLoadingDialog(Get.context!);
    dynamic result = await profileService.getLatLng(placeId);
    if (result != null) {
      driverLocLatLng = LatLng(result['lat'], result['lng']);
    }
    Get.back();
  }

  addressOnChange(value) {
    if (value.isEmpty) {
      showSuggestion = false;
    } else {
      showSuggestion = true;
    }
    notifyListeners();
    debouncing(
      fn: () {
        if(value.isNotEmpty){
          autoCompletePlaces(address: addressCon.text);
        }
      },
    );
  }

  cnicOnChange(text) {
    final int maxLength = 15;
    final List<int> dashPositions = [5, 12];
    String formattedText = '';
    String cleanedText = text.replaceAll(RegExp(r'[^\d]'), '');

    int cleanedLength = cleanedText.length;
    int currentIndex = 0;

    for (var dashPosition in dashPositions) {
      if (currentIndex >= cleanedLength) break;

      if (dashPosition <= cleanedLength) {
        formattedText +=
            cleanedText.substring(currentIndex, dashPosition) + '-';
        currentIndex = dashPosition;
      }
    }

    if (currentIndex < cleanedLength) {
      formattedText += cleanedText.substring(currentIndex, cleanedLength);
    }

    if (formattedText.length > maxLength) {
      formattedText = formattedText.substring(0, maxLength);
    }

    int cursorPosition = cnicCon.selection.baseOffset;

    if (cursorPosition > 5 &&
        cursorPosition <= formattedText.length &&
        dashPositions.contains(cursorPosition)) {
      cursorPosition++;
    } else if (cursorPosition > formattedText.length) {
      cursorPosition = formattedText.length;
    }

    cnicCon.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  String? addressValidator(val) {
    if (val.toString().isEmpty) {
      return addressRequiredKey.tr;
    } else {
      return null;
    }
  }

  String? nameValidator(val) {
    if (val.toString().isEmpty) {
      return nameRequiredKey.tr;
    } else {
      return null;
    }
  }

  String? cnicValidator(val) {
    RegExp regex = new RegExp(r"^[0-9]{5}-[0-9]{7}-[0-9]{1}$");
    if (val.toString().isEmpty) {
      return cnicNoRequiredKey.tr;
    } else if (!regex.hasMatch(val.toString())) {
      return cnicValidKey.tr;
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

  String? surNameValidator(val) {
    if (val.toString().isEmpty) {
      return surnameRequiredKey.tr;
    } else {
      return null;
    }
  }

  void profileImagePicker(File? image) {
    profileImage = image;
    notifyListeners();
  }

  void delLicenseFrontImage() {
    licenseFrontImage = null;
    driverLicenseFrontImageLink = '';
    notifyListeners();
  }

  void delLicenseBackImage() {
    licenseBackImage = null;
    driverLicenseBackImageLink = '';
    notifyListeners();
  }

  void selectLicenseFrontImage(image) {
    licenseFrontImage = image;
    notifyListeners();
  }

  void selectLicenseBackImage(image) {
    licenseBackImage = image;
    notifyListeners();
  }

  void delCnicFrontImage() {
    cnicFrontImage = null;
    driverCnicFrontImageLink = '';
    notifyListeners();
  }

  void delCnicBackImage() {
    cnicBackImage = null;
    driverCnicBackImageLink = '';
    notifyListeners();
  }

  void selectCnicFrontImage(image) {
    cnicFrontImage = image;
    notifyListeners();
  }

  void selectCnicBackImage(image) {
    cnicBackImage = image;
    notifyListeners();
  }

  bool imagesValidation() {
    if (StaticInfo.driverModel!.isProfileCompleted) {
      return true;
    } else if (licenseFrontImage != null &&
        licenseBackImage != null &&
        cnicFrontImage != null &&
        cnicBackImage != null) {
      return true;
    } else {
      imageValidationCheck = true;
      notifyListeners();
      return false;
    }
  }

  Color borderColor({File? image}) {
    if (imageValidationCheck) {
      if (image == null) {
        return redColor;
      } else {
        return profileBackColor;
      }
    } else {
      return profileBackColor;
    }
  }

  Future<void> updateDriverProfile() async {
    if (StaticInfo.driverModel!.isProfileCompleted) {
      startingAddress = StaticInfo.driverModel!.driverLocation.address!;
      driverLocLatLng = LatLng(
          double.parse(StaticInfo.driverModel!.driverLocation.lat!),
          double.parse(StaticInfo.driverModel!.driverLocation.long!));
      Get.to(() => VehicleDetailView(
        address: startingAddress!,
      ));
    } else {
      startingAddress = addressCon.text.trim();
    }

    profileService.driverAddress = startingAddress!;
    profileService.driverLat = driverLocLatLng!.latitude.toString();
    profileService.driverLng = driverLocLatLng!.longitude.toString();
    profileService.driverName = nameCon.text.trim();
    profileService.driverSurName = surNameCon.text.trim();
    profileService.driverPhoneNo = phoneCon.text.trim();
    profileService.driverLicenseFrontImage =
        (licenseFrontImage != null) ? licenseFrontImage!.path : '';
    profileService.driverLicenseBackImage =
        (licenseBackImage != null) ? licenseBackImage!.path : '';
    profileService.driverCnicFrontImage =
        (cnicFrontImage != null) ? cnicFrontImage!.path : '';
    profileService.driverCnicBackImage =
        (cnicBackImage != null) ? cnicBackImage!.path : '';
    profileService.driverImagePath =
        (profileImage != null) ? profileImage!.path : '';
    profileService.cnicNumber = cnicCon.text.trim();

    print('driver name is ${nameCon.text}');
    Get.to(() => VehicleDetailView(
          address: startingAddress!,
        ));
  }
}
