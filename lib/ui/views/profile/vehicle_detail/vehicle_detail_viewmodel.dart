import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pickup/models/user_model.dart';
import 'package:pickup/models/vehicle_types_model.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/services/profile_service.dart';
import 'package:pickup/src/app/apiErrorsMessage.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/bottom_bar/bottom_bar_view.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import '../../../../services/shared_preference.dart';

class VehicleDetailViewModel extends BaseViewModel with CommonUiService {
  ProfileService profileService = locator<ProfileService>();
  bool isShow = false;
  int i = 0;
  VehicleTypesModel? vehicleTypeVal;
  int? numOfSeats;
  ScrollController scrollController = ScrollController();
  DateTime selectedStartTime = DateTime.now();
  DateTime selectedEndTime = DateTime.now();
  ScrollController screenScrollController = ScrollController();
  TextEditingController startTimeCon = TextEditingController();
  TextEditingController vehicleModelYearCon = TextEditingController();
  TextEditingController numberPlateCon = TextEditingController();
  TextEditingController maintenanceDateCon = TextEditingController();
  TextEditingController endTimeCon = TextEditingController();
  TextEditingController addressCon = TextEditingController();
  TextEditingController vehicleMakeCon = TextEditingController();
  List<VehicleTypesModel> vehicleTypesList = [];
  List<int> numOfSeatsList = [];
  List<File> carImageList = [];
  List<File> documentImagesList = [];
  List<dynamic> savedCarImages = [];
  List<dynamic> savedDocumentsImages = [];
  List<int> deleteImagesId = [];
  List<int> deleteDocumentImagesId = [];

  initialise(String address) {
    CustomDialog.showLoadingDialog(Get.context!);
    if (address.isNotEmpty) {
      addressCon.text = address;
    }
    var outputFormat =
    DateFormat('dd-MM-yyyy');
    var timeFormat =
    DateFormat('hh:mm a');
    // var outputDate =

    if (StaticInfo.driverModel!.isProfileCompleted) {
      startTimeCon.text = timeFormat.format(StaticInfo.vehicleModel!.availableFrom!);
      vehicleModelYearCon.text = StaticInfo.vehicleModel!.vehicleModelYear!;
      numberPlateCon.text = StaticInfo.vehicleModel!.vehicleNumberPlate!;
      maintenanceDateCon.text =outputFormat.format(StaticInfo.vehicleModel!.maintenanceDate!);
      vehicleMakeCon.text = StaticInfo.vehicleModel!.vehicleMake!;
      endTimeCon.text = timeFormat.format(StaticInfo.vehicleModel!.availableTill!);
      addressCon.text = address;

    }
    notifyListeners();
    getVehicleTypes();
    if(StaticInfo.vehicleModel != null){
      savedCarImages.clear();
      savedDocumentsImages.clear();
      savedCarImages.addAll(StaticInfo.vehicleModel!.vehicleImages);
      savedDocumentsImages.addAll(StaticInfo.vehicleModel!.vehicleDocuments);
    }
  }

  void addNewCarImage({required File image}) {
    carImageList.add(image);
    rebuildUi();
  }

  void addNewDocumentImage({required File image}) {
    documentImagesList.add(image);
    rebuildUi();
  }

  void deleteImage({required int index, required String listName, int? id}) {
    if (listName == 'carImages') {
      carImageList.removeAt(index);
    } else {
      savedCarImages.removeAt(index);
      profileService.deleteImage(imageId: id);
      //deleteImagesId.add(id!);
    }
    rebuildUi();
  }

  void deleteDocumentImage(
      {required int index, required String listName, int? id}) {
    if (listName == 'documentImage') {
      documentImagesList.removeAt(index);
    } else {
      savedDocumentsImages.removeAt(index);
      profileService.deleteImage(imageId: id);
    }
    rebuildUi();
  }

  Future<void> getVehicleTypes() async {
    bool connectivity = await check();
    if(connectivity){
      http.Response response = await profileService.getVehicleTypes();

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['success'] == true) {
          List<dynamic> data = decodedResponse['data'];
          vehicleTypesList =
              data.map((item) => VehicleTypesModel.fromJson(item)).toList();
          if (StaticInfo.driverModel!.isProfileCompleted) {
            vehicleTypeVal = vehicleTypesList.firstWhere((element) =>
                element.id == StaticInfo.vehicleModel!.vehicleType);
            numOfSeats = StaticInfo.vehicleModel!.vehicleSeats;
            generateList(
                minVal: vehicleTypeVal!.minimumSeat,
                maxVal: vehicleTypeVal!.maximumSeat);
          }

          // print('vehicle list is ${vehicleTypesList[0].label}');
        } else {
          showCustomErrorTextToast(
              context: Get.context!, text: decodedResponse['message']);
        }
        rebuildUi();
        Get.back();
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    }else{
      Get.back();
      showCustomWarningTextToast(context: Get.context!, text: checkInternetKey.tr);
    }
  }

  void generateList({required int minVal, required int maxVal}) {
    CustomDialog.showLoadingDialog(Get.context!);
    numOfSeatsList.clear();
    for (int i = minVal; i <= maxVal; i++) {
      numOfSeatsList.add(i);
    }
    isShow = true;
    print(numOfSeatsList);
    Get.back();
    rebuildUi();
  }

  Future<void> addVehicle(
  //{
    // required String modelTypeId,
    // required String modelYear,
    // required int numOfSeats,
    // required String numberPlate,
    // required String maintenanceData,
    // required String startTime,
    // required String endTime,
    // required String address,
    // required String vehicleMake,
  //}
  ) async {
    CustomDialog.showLoadingDialog(Get.context!);
    print('vehicle add');
    bool connectivity = await check();
    if(connectivity){
      List<String> newCarImageList = [];
      List<String> newDocumentList = [];
      for (File data in carImageList) {
        newCarImageList.add(data.path);
      }
      for (File data in documentImagesList) {
        newDocumentList.add(data.path);
      }

      http.StreamedResponse response = await profileService.addVehicle(
        carImage: newCarImageList,
        documentImage: newDocumentList,
        modelTypeId: vehicleTypeVal!.id.toString(),
        modelYear: vehicleModelYearCon.text.trim(),
        numOfSeats: numOfSeats!,
        numberPlate: numberPlateCon.text.trim(),
        maintenanceData: maintenanceDateCon.text.trim(),
        startTime: startTimeCon.text.trim(),
        endTime: endTimeCon.text.trim(),
        address: addressCon.text.trim(),
        vehicleMake: vehicleMakeCon.text.trim(),
        deleteCarImageIdList: deleteImagesId,
        deleteDocumentImageIdList: deleteDocumentImagesId,
        vehicleColor: "White"
      );

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var decodedResponse = json.decode(responseString);
        print('updated data is $decodedResponse');
        debugPrint(responseString);
        if (decodedResponse['success'] == true) {
          UserModel newModel = UserModel.fromJson(decodedResponse);
          StaticInfo.driverModel = newModel.data.driver;
          StaticInfo.vehicleModel = newModel.data.vehicle;
          SharedPreferencesService().saveUser(newModel);
          print('vehicle detail ${newModel.data.authToken}');
          Get.back();
          Get.to(() => BottomBarView(index: 2,));
          showCustomSuccessTextToast(
              context: Get.context!, text: decodedResponse['message']);
        } else {
          showCustomErrorTextToast(
              context: Get.context!, text: decodedResponse['message']);
          Get.back();
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    }else {
      showCustomErrorTextToast(context: Get.context!, text: checkInternetKey.tr);
      Get.back();
    }
  }

}
