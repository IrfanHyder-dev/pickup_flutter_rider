import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickup/models/fetch_child_details.dart';
import 'package:pickup/models/routes_response_model.dart' as model;
import 'package:pickup/models/user_firebase_model.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/services/firebase/firebase_services.dart';
import 'package:pickup/services/routes_services.dart';
import 'package:pickup/src/app/apiErrorsMessage.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/enums/app_enums.dart';
import 'package:pickup/src/app/global_variables/app_global_variables.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart' as locationPCG;

class PickDropMapViewModel extends BaseViewModel with CommonUiService {
  bool isSelected = false;
  bool allChildrenDropped = false;
  RideShiftType rideShiftType = RideShiftType.not_available;
  double containerHeight = 300.0;
  bool isLoading = false;
  String timeToDisplay = '';
  Timer? timer;
  int remainingTimeInSeconds = 0;
  final int countdownInSeconds = 1;
  UserFirebaseModel? driverFirebaseModel;
  int timerIsStartFor = -1;

  /// variable for checking either select all functionality show or not
  int pickedChildLength = 0;

  /// variable for checking all children dropped or not
  int droppedChildLength = 0;

  FetchChildDetails? childDetails;
  List<FetchChildListModel> remainingChildToPick = [];
  List<ChangeChildStatus> changeChildStatusList = [];
  RoutesServices routesServices = locator<RoutesServices>();
  ScrollController scrollController = ScrollController();

  List<PointLatLng> routePolyline = [];
  final List<LatLng> polylineCoordinates = [];

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor carMarkerIcon = BitmapDescriptor.defaultMarker;

  /*------------>>>> Google map and location stream variables <<<------------*/

  StreamSubscription<UserFirebaseModel>? firebaseUserStream;

  final List<Polyline> polyLines = [];
  Set<Marker> markers = {};
  Map<MarkerId, Marker> driverMarker = <MarkerId, Marker>{};
  Completer<GoogleMapController> mapCompleter = Completer();
  RideStatusModel? rideStatusModel;

/*-------------------------------------------------------------------------*/

  setLoader({required bool loading}) {
    isLoading = loading;
    debugPrint("loader is $isLoading");
    notifyListeners();
  }

  initialise(
      {required final RideShiftType rideStartTimeData,
      required BuildContext context}) async {
    setLoader(loading: true);
    rideShiftType = rideStartTimeData;
    /*============ fetch ride status ========*/
    /* --------->>>> Fetching children markers location and details <<<<----------*/
    await locationPermissionGranted(context);
    setLoader(loading: false);
    notifyListeners();
  }

  Future<void> locationPermissionGranted(BuildContext context) async {
    /*============ fetch ride status ========*/
    /* --------->>>> Fetching children markers location and details <<<<----------*/
    /* --------->>>> Creating markers <<<<-----------*/
    _createMarkerImageFromAsset();
    await fetchChildDetails();
    /*============ fetch driver and ride status ========*/
    await fetchDriverAndRideStatusDoc();

    /*  check date if it's previous date  then reset statuses and ride date*/
    await resetDailyStatus();

    /* If Ride is Finished show ride finished dialog*/
    if (rideStatusModel?.morningRideStatus == RideStatus.finished &&
        rideStatusModel?.eveningRideStatus == RideStatus.finished) {
      CustomDialog.showRideFinishedDialog(context);
    }
    if (rideStatusModel?.morningRideStatus == RideStatus.started ||
        rideStatusModel?.eveningRideStatus == RideStatus.started) {
      await decodeRoutePolyline();
    }
    /* -->>> Implement Stream to driver firebase function <<<---*/
    driverFirebaseStream(
        firebaseUSerID: "${StaticInfo.driverModel?.driverFirebaseID ?? ""}");
    checkDriverIsInArrivedSoonRadius();
    notifyListeners();
  }

  Future<void> fetchChildDetails() async {
    bool connectivity = await check();
    if (connectivity) {
      try {
        http.Response response = await routesServices.fetchChildDetails();
        if (response.statusCode == 200) {
          var decodedResponse = json.decode(response.body);
          print(
              '===========================> child details ${decodedResponse}');

          if (decodedResponse["success"]) {
            childDetails = FetchChildDetails.fromJson(decodedResponse);

            for (var child in childDetails!.fetchedChildList!) {
              if (child.rideStatus == ArrivalStatus.not_arrived) {
                remainingChildToPick.add(child);
              }
            }
          } else {
            showCustomWarningTextToast(
                context: Get.context!, text: decodedResponse["message"]);
          }
        } else {
          ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
        }
      } on SocketException {
        showCustomWarningTextToast(
            context: Get.context!, text: "Socket Exception");
      } catch (e) {}
    } else {
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
    notifyListeners();
  }

  Future<void> fetchDriverAndRideStatusDoc() async {
    String? driverFirebaseID = await FirebaseServices.checkUserInDB(
        StaticInfo.driverModel?.driverFirebaseID ?? "");
    if (driverFirebaseID != null) {
      /* fetch user data*/
      driverFirebaseModel =
          await FirebaseServices.fetchUSerData(driverFirebaseID);
      rideStatusModel =
          await FirebaseServices.getRideStatusDoc(driverFirebaseID);

      List<ChildList> childList = [];
      for (var data in childDetails?.fetchedChildList ?? []) {
        ChildList child = ChildList(
            id: data.child?.id ?? 0,
            reamingTimerTimeInSeconds: 0,
            arrivalStatus: ArrivalStatus.not_arrived,
            arrivalTime: Timestamp.now());
        childList.add(child);
      }

      if (rideStatusModel == null) {
        rideStatusModel = RideStatusModel(
            childList: childList,
            rideDate: Timestamp.now(),
            rideStatusId: DateTime.now().millisecondsSinceEpoch.toString(),
            driverFirebaseId: driverFirebaseID,
            morningRideStatus: RideStatus.not_started,
            eveningRideStatus: RideStatus.not_started);
      } else {
        rideStatusModel?.childList = childList;
      }
      await FirebaseServices.setDriverRideStatus(
          rideStatusModel: rideStatusModel!);
    } else {
      debugPrint("Driver not found in firebase");
      Get.back();
      setLoader(loading: false);
      showCustomErrorTextToast(context: Get.context!, text: "Driver not found in firebase ");
    }
    notifyListeners();
  }

  Future<void> resetDailyStatus() async {
    /*  check date if it's previous date  then reset statuses and ride date*/
    /* Check ride_date is of today's or any previous day*/
    DateTime now = DateTime.now();
    final rideDate = rideStatusModel?.rideDate?.toDate();
    int difference = DateTime(rideDate!.year, rideDate.month, rideDate.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;

    if (difference.isNegative) {
      /*If difference is negative means firebase contains previous date */
      /* So, We need to update date and reset ride statuses*/
      rideStatusModel?.rideDate = Timestamp.now();
      rideStatusModel?.morningRideStatus = RideStatus.not_started;
      rideStatusModel?.eveningRideStatus = RideStatus.not_started;
      await FirebaseServices.setDriverRideStatus(
          rideStatusModel: rideStatusModel!);
    }
  }

  Future<void> decodeRoutePolyline() async {
    print('=====================> decode polyline method call');
    model.RoutesModel? routesResponseModel = fetchMorningOREveningRoutes();
    /*------->>> driver data fetched then fetch decoded poly-lines and marker <<<<<-------*/
    if (routesResponseModel != null) {
      PolylinePoints polylinePoints = PolylinePoints();
      String encodePolyline = routesResponseModel.encodedPolyline ?? "";
      routePolyline = await polylinePoints.decodePolyline(encodePolyline);
      List<int> locationOrder =
          routesResponseModel.optimizedIntermediateWaypointIndex ?? [];
      List<FetchChildListModel> dumyList = [];

      if (locationOrder.length > 1) {
        print(
            '================ child list list list ${childDetails!.fetchedChildList!.length}');
        print('================ child list list list ${locationOrder.length}');
        for (int i = 0; i < childDetails!.fetchedChildList!.length; i++) {
          dumyList.add(childDetails!.fetchedChildList![locationOrder[i]]);
        }

        childDetails!.fetchedChildList!.clear();
        childDetails!.fetchedChildList!.addAll(dumyList);
      }

      /// move not_going or dropped  children at the end of list
      if (childDetails!.fetchedChildList!.length > 1) {
        for (var child in dumyList) {
          if (child.rideStatus == ArrivalStatus.not_going ||
              child.rideStatus == ArrivalStatus.dropped) {
            var index = childDetails!.fetchedChildList!
                .indexWhere((element) => element.id == child.id);
            childDetails!.fetchedChildList!.insert(
                childDetails!.fetchedChildList!.length,
                childDetails!.fetchedChildList![index]);
            childDetails!.fetchedChildList!.removeAt(index);
          }
        }
      }
      addMarker();
      getPolyline();
    } else {
      print("StaticInfo.routesResponseModel.routes list is empty");
    }
    notifyListeners();
  }

  void addMarker() {
    markers.clear();
    /* add driver marker*/
    driverMarker[MarkerId('${StaticInfo.driverModel!.id}')] = Marker(
      markerId: MarkerId('${StaticInfo.driverModel!.id}'),
      position: LatLng(
        double.parse(StaticInfo.driverModel!.driverLocation.lat!),
        double.parse(StaticInfo.driverModel!.driverLocation.long!),
      ),
      icon: carMarkerIcon,
    );

    /* add child markers*/
    for (int i = 0; i < childDetails!.fetchedChildList!.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId(
            '${childDetails!.fetchedChildList![i].child?.name}${childDetails!.fetchedChildList![i].child?.pickUpLat}',
          ),
          position: LatLng(
              double.parse(
                  childDetails!.fetchedChildList![i].child?.pickUpLat ?? "0"),
              double.parse(
                  childDetails!.fetchedChildList![i].child?.pickUpLong ?? "0")),
          icon: markerIcon,
          infoWindow: InfoWindow(
            title: childDetails!.fetchedChildList![i].child?.name,
            snippet: childDetails!.fetchedChildList![i].child?.name,
          ),
        ),
      );
    }
    markers.add(
      Marker(
        markerId: MarkerId('${StaticInfo.driverModel!.driverDropOffLat}'),
        position: LatLng(
            double.parse(StaticInfo.driverModel!.driverDropOffLat!),
            double.parse(StaticInfo.driverModel!.driverDropOffLong!)),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    notifyListeners();
  }

  void getPolyline() {
    routePolyline.forEach(
      (PointLatLng point) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      },
    );

    routePolyline.forEach(
      (PointLatLng point) {
        polyLines.add(
          Polyline(
            polylineId: PolylineId('polyLinePoint${point.latitude}'),
            color: Theme.of(Get.context!).primaryColor,
            width: 4,
            points: polylineCoordinates,
          ),
        );
      },
    );

    notifyListeners();
  }

  void _createMarkerImageFromAsset() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/marker.png")
        .then(
      (icon) {
        markerIcon = icon;
      },
    );

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/car_marker_icon.png")
        .then(
      (icon) {
        carMarkerIcon = icon;
      },
    );
  }

  Future<void> rideStartOnTap(BuildContext context) async {
    // setLoader(loading: true);
    // /*------------- Check location permission <<<<<--------------*/
    // bool isLocationGranted = await isLocationPermissionGranted();
    // if (isLocationGranted) {
    /*------------- initiate function when ride started <<<<<--------------*/
    await rideStartFunctions(context);

    // setLoader(loading: false);
    // } else {
    //   setLoader(loading: false);
    //   // CustomDialog.showSettingDialog(context);
    // }

    notifyListeners();
  }

  Future<void> rideStartFunctions(BuildContext context) async {
    print('getting current location');

    /*------------- set Driver Ride status Doc to started <<<<<--------------*/
    if (rideStatusModel?.morningRideStatus == RideStatus.not_started) {
      rideStatusModel?.morningRideStatus = RideStatus.started;
      await startRideAndResetRideStatus(rideShiftType: RideShiftType.morning);
    } else if (rideStatusModel?.morningRideStatus == RideStatus.finished &&
        rideStatusModel?.eveningRideStatus == RideStatus.not_started) {
      rideStatusModel?.eveningRideStatus = RideStatus.started;
      await startRideAndResetRideStatus(rideShiftType: RideShiftType.evening);
    }
    await FirebaseServices.setDriverRideStatus(
        rideStatusModel: rideStatusModel!);

    await decodeRoutePolyline();
    /* In this function we are getting current location and setting to firebase*/
    await getLocation(context);
  }

  Future<void> startRideAndResetRideStatus(
      {required RideShiftType rideShiftType}) async {
    /// this function reset the ride status in database and generate notification for parents that ride start
    print('start ride api function');
    bool connectivity = await check();
    if (connectivity) {
      try {
        Position currentLatLng = await Geolocator.getCurrentPosition();
        print('start ride api function ${currentLatLng.latitude}');
        http.Response response =
            await routesServices.startRideAndResetRideStatus(
                rideShiftType: rideShiftType.name,
                currentLocation: currentLatLng);
        if (response.statusCode == 200) {
          var decodedResponse = json.decode(response.body);
          if (decodedResponse["success"]) {
            await fetchChildDetails();
            return;
          } else {
            showCustomWarningTextToast(
                context: Get.context!, text: decodedResponse["message"]);
          }
        } else {
          ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
        }
      } on SocketException {
        showCustomWarningTextToast(
            context: Get.context!, text: "Socket Exception");
      } catch (e) {}
    } else {
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
  }

  void handleSwipe(DragUpdateDetails details) {
    containerHeight -= details.primaryDelta!;
    containerHeight = containerHeight.clamp(43.5, 400.0);
    notifyListeners();
  }

  void selectAllCheckBox() {
    isSelected = !isSelected;
    for (int i = 0; i < childDetails!.fetchedChildList!.length; i++) {
      childDetails!.fetchedChildList![i].child?.isSelected = isSelected;
    }
    notifyListeners();
  }

  void checkBoxStatus(int index) {
    bool? currentStatus =
        childDetails!.fetchedChildList![index].child?.isSelected;
    childDetails!.fetchedChildList![index].child?.isSelected = !currentStatus!;
    notifyListeners();
  }

  model.RoutesModel? fetchMorningOREveningRoutes() {
    if (driverFirebaseModel?.morningShift != null &&
        rideStatusModel?.morningRideStatus == RideStatus.started) {
      return driverFirebaseModel?.morningShift;
    } else if (driverFirebaseModel?.eveningShift != null &&
        rideStatusModel?.eveningRideStatus == RideStatus.started) {
      return driverFirebaseModel?.eveningShift;
    }
    return null;
  }

  Future<void> checkDriverIsInArrivedSoonRadius() async {
    /// this function will check that is driver near to child location after every 30 seconds until driver picked all child
    int totalTime = 0;
    int timerIncrementValue = 1;
    List<int> childToRemoveFromList = [];

    checkDriverIsInRadiusTimer =
        Timer.periodic(Duration(seconds: timerIncrementValue), (timer) async {
      totalTime += timerIncrementValue;
      if (totalTime % 30 == 0) {
        for (var child in remainingChildToPick) {
          bool isDriverArrivedSoon = await isDriverInRadius(
            existingLat: double.parse(child.child?.pickUpLat ?? '0'),
            existingLng: double.parse(child.child?.pickUpLong ?? '0'),
            currentLat: driverFirebaseModel!.location!.latitude,
            currentLng: driverFirebaseModel!.location!.longitude,
            rangeInMeter: 300,
          );
          if (isDriverArrivedSoon) {
            /// call the function which hit the api for push notification
            await notifyParentDriverArrivedSoon(childId: child.child?.id ?? -1);

            /// update the child ride status on firebase
            int? index = rideStatusModel?.childList
                ?.indexWhere((element) => (element.id == child.child!.id));
            print(
                '===================  arrival sooon $index    ${child.child!.id}');
            if (index != null) {
              rideStatusModel?.childList?[index].arrivalStatus =
                  ArrivalStatus.arrival_soon;
              rideStatusModel?.childList?[index].arrivalTime = Timestamp.now();
            }
            await FirebaseServices.setDriverRideStatus(
                rideStatusModel: rideStatusModel!);
            childToRemoveFromList.add(child.id!);
          }
        }

        /// remove the children who have been notified
        remainingChildToPick.removeWhere(
            (element) => childToRemoveFromList.contains(element.id));
      }

      if (remainingChildToPick.length == 0) {
        cancelTimer(checkDriverIsInRadiusTimer);
      }
    });
  }

  /// Function for push arrived soon notification
  Future<void> notifyParentDriverArrivedSoon({required int childId}) async {
    print('=================> notify parent func called');
    bool connectivity = await check();
    if (connectivity) {
      try {
        http.Response response = await routesServices
            .notifyParentDriverArrivedSoon(childId: childId);
        if (response.statusCode == 200) {
          var decodedResponse = json.decode(response.body);
          if (decodedResponse["success"]) {
            print('=================> parent notifed that driver arrive soon');
          } else {
            showCustomWarningTextToast(
                context: Get.context!, text: decodedResponse["message"]);
          }
        } else {
          ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
        }
      } on SocketException {
        showCustomWarningTextToast(
            context: Get.context!, text: "Socket Exception");
      } catch (e) {}
    } else {
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
    notifyListeners();
  }

  bool showRideStartButton() {
    if (rideStatusModel?.morningRideStatus == RideStatus.not_started) {
      return true;
    } else if (rideStatusModel?.morningRideStatus == RideStatus.finished &&
        rideStatusModel?.eveningRideStatus == RideStatus.not_started) {
      return true;
    } else {
      return false;
    }
  }

  /// changing the status of driver against child
  Future<void> onTapRideStatus(
      {required bool isAllSelected, int? index}) async {
    print('=========================================> on tap ride status');
    List<int> childId = [];
    ArrivalStatus status;
    bool isDriverArrived;
    double currentChildLat = 0.0;
    double currentChildLng = 0.0;

    if (isAllSelected) {
      changeChildStatusList.clear();
      for (var child in childDetails!.fetchedChildList!) {
        childId.add(child.child!.id!);
        changeChildStatusList.add(
          ChangeChildStatus(
            quotationId: child.quotationId ?? -1,
            childId: child.child!.id ?? -1,
          ),
        );
      }
      rideStatus(
        status: ArrivalStatus.dropped,
      );
    } else {
      changeChildStatusList.clear();
      changeChildStatusList.add(
        ChangeChildStatus(
          quotationId:
              childDetails!.fetchedChildList![index!].quotationId ?? -1,
          childId: childDetails!.fetchedChildList![index].child!.id ?? -1,
        ),
      );
      if (childDetails!.fetchedChildList![index].rideStatus ==
          ArrivalStatus.not_arrived) {
        /// check if driver is in the define radius then change the status to arrived

        if (rideStatusModel?.morningRideStatus == RideStatus.started) {
          currentChildLat = double.parse(
              childDetails!.fetchedChildList![index].child?.pickUpLat ?? '0');
          currentChildLng = double.parse(
              childDetails!.fetchedChildList![index].child?.pickUpLong ?? '0');
        } else if (rideStatusModel?.eveningRideStatus == RideStatus.started) {
          currentChildLat = double.parse(
              childDetails!.fetchedChildList![index].child?.dropOffLat ?? '0');
          currentChildLng = double.parse(
              childDetails!.fetchedChildList![index].child?.dropOffLong ?? '0');
        }
        isDriverArrived = await isDriverInRadius(
          existingLat: currentChildLat,
          existingLng: currentChildLng,
          currentLat: driverFirebaseModel!.location!.latitude,
          currentLng: driverFirebaseModel!.location!.longitude,
          rangeInMeter: 250,
        );
        if (isDriverArrived) {
          cancelTimer(timer);

          startTimer(
              childId: childDetails!.fetchedChildList![index].child!.id!);
          status = ArrivalStatus.arrived;
          rideStatus(
            status: status,
          );
        } else {
          showCustomWarningTextToast(
              context: Get.context!,
              text: "Please reach at the pickup location to proceed");
        }
      } else if (childDetails!.fetchedChildList![index].rideStatus ==
          ArrivalStatus.arrived) {
        timeToDisplay = '';
        cancelTimer(timer);
        status = ArrivalStatus.picked;
        pickedChildLength = pickedChildLength + 1;
        rideStatus(
          status: status,
        );
      } else {
        status = ArrivalStatus.dropped;
        droppedChildLength = droppedChildLength + 1;
        if (droppedChildLength == childDetails!.fetchedChildList!.length) {
          pickedChildLength = 0;
        }
        rideStatus(
          status: status,
        );
      }
    }
  }


  /// function to call the api to change the driver status against child
  Future rideStatus({
    required ArrivalStatus status,
  }) async {
    bool connectivity = await check();
    if (connectivity) {
      http.StreamedResponse response = await routesServices.rideStatus(
        changeChildStatusList: changeChildStatusList,
        status: status.name,
      );
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var decodedResponse = json.decode(responseString);
        log(responseString);
        if (decodedResponse["success"]) {
          /// set driver arrival status and time on firebase
          for (var data in changeChildStatusList) {
            int? index = rideStatusModel?.childList
                ?.indexWhere((element) => (element.id == data.childId));
            print(
                '================ arival status $index   ${changeChildStatusList.length}   ${changeChildStatusList[0].childId}');
            if (index != null) {
              rideStatusModel?.childList?[index].arrivalStatus = status;
              rideStatusModel?.childList?[index].arrivalTime = Timestamp.now();
            }
          }
          await FirebaseServices.setDriverRideStatus(
              rideStatusModel: rideStatusModel!);

          for (var data in changeChildStatusList) {
            var index = childDetails!.fetchedChildList!
                .indexWhere((element) => element.child!.id == data.childId);
            childDetails!.fetchedChildList![index].rideStatus = status;
          }
          if (status == ArrivalStatus.dropped &&
              changeChildStatusList.length <
                  childDetails!.fetchedChildList!.length) {
            for (var data in changeChildStatusList) {
              var index = childDetails!.fetchedChildList!
                  .indexWhere((element) => element.child!.id == data.childId);
              childDetails!.fetchedChildList!.insert(
                  childDetails!.fetchedChildList!.length,
                  childDetails!.fetchedChildList![index]);
              childDetails!.fetchedChildList!.removeAt(index);
            }
          }
          notifyListeners();
        } else {
          showCustomWarningTextToast(
              context: Get.context!, text: decodedResponse["message"]);
        }
      } else {
        ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
      }
    } else {
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
  }

  /// update the button text when driver status change against each child
  String btnText(int index) {
    ArrivalStatus? status = childDetails?.fetchedChildList?[index].rideStatus;

    if (status == ArrivalStatus.not_arrived) {
      return arrivedKey.tr;
    } else if (status == ArrivalStatus.arrived) {
      return pickedKey.tr;
    } else if (status == ArrivalStatus.picked) {
      return dropKey.tr;
    } else if (status == ArrivalStatus.not_going) {
      return skippedBtnTextKey.tr;
    }
    return 'Dropped';
  }

  /// function which return the string shown on finish ride button
  String finishRideBtnText() {
    if (pickedChildLength == (childDetails?.fetchedChildList?.length ?? 0)) {
      return dropKey.tr;
    } else {
      return finishRideKey.tr;
    }
  }

  /// this function call when driver skip any child
  Future<void> skipChild({
    required int childId,
    required int quotationId,
    required int indexOfFetchChildList,
    required BuildContext context,
  }) async {
    CustomDialog.showLoadingDialog(context);
    bool connectivity = await check();
    if (connectivity) {
      try {
        http.Response response = await routesServices.skipChild(
            childId: childId, quotationId: quotationId);
        if (response.statusCode == 200) {
          var decodedResponse = json.decode(response.body);
          print(
              '==================================>  skip child response ${decodedResponse}');
          if (decodedResponse["success"]) {
            /// update child status model locally
            childDetails?.fetchedChildList?[indexOfFetchChildList].rideStatus =
                ArrivalStatus.not_going;
            childDetails!.fetchedChildList![indexOfFetchChildList].rideStatus =
                ArrivalStatus.not_going;

            /// move skipped child child at the end of the list
            if (childDetails!.fetchedChildList!.length > 1) {
              childDetails!.fetchedChildList!.insert(
                  childDetails!.fetchedChildList!.length,
                  childDetails!.fetchedChildList![indexOfFetchChildList]);
              childDetails!.fetchedChildList!.removeAt(indexOfFetchChildList);
            }

            /// update child ride status on firebase
            int? index = rideStatusModel?.childList
                ?.indexWhere((element) => (element.id == childId));
            if (index != null) {
              rideStatusModel?.childList?[index].arrivalStatus =
                  ArrivalStatus.not_going;
              rideStatusModel?.childList?[index].arrivalTime = Timestamp.now();
              await FirebaseServices.setDriverRideStatus(
                  rideStatusModel: rideStatusModel!);
            }
            timeToDisplay = '';
            if (timerIsStartFor == childId) {
              cancelTimer(timer);
            }
            Get.back();
            notifyListeners();
          } else {
            showCustomWarningTextToast(
                context: Get.context!, text: decodedResponse["message"]);
          }
        } else {
          ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
        }
      } on SocketException {
        showCustomWarningTextToast(
            context: Get.context!, text: "Socket Exception");
      } catch (e) {}
    } else {
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
  }

  /// function to perform action on Tap on finish ride btn
  Future<void> onTapFinishRideBtn() async {
    bool connectivity = await check();
    RideShiftType rideShift = RideShiftType.not_available;
    if (pickedChildLength == childDetails!.fetchedChildList!.length) {
      droppedChildLength = pickedChildLength;
      pickedChildLength = 0;
      onTapRideStatus(isAllSelected: true);
    }

/*------------- set Driver Ride status Doc to started <<<<<--------------*/

    if (rideStatusModel?.morningRideStatus != RideStatus.finished) {
      rideShift = RideShiftType.morning;
      rideStatusModel?.morningRideStatus = RideStatus.finished;
    } else if (rideStatusModel?.eveningRideStatus != RideStatus.finished) {
      rideShift = RideShiftType.evening;
      rideStatusModel?.eveningRideStatus = RideStatus.finished;
    }

    if (connectivity) {
      try {
        Position currentLatLng = await Geolocator.getCurrentPosition();
        print('finish ride api function ${currentLatLng.latitude}');
        http.Response response = await routesServices.finishRideStatus(
            rideShiftType: rideShift.name, currentLocation: currentLatLng);
        if (response.statusCode == 200) {
          var decodedResponse = json.decode(response.body);
          if (decodedResponse["success"]) {
            await FirebaseServices.setDriverRideStatus(
                rideStatusModel: rideStatusModel!);
            disposeFirebaseUserStream();
// Get.back();
            return;
          } else {
            showCustomWarningTextToast(
                context: Get.context!, text: decodedResponse["message"]);
          }
        } else {
          ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
        }
      } on SocketException {
        showCustomWarningTextToast(
            context: Get.context!, text: "Socket Exception");
      } catch (e) {}
    } else {
      showCustomWarningTextToast(
          context: Get.context!, text: checkInternetKey.tr);
    }
// Get.back();
  }

  ///Firebase and Location services
  Future<bool> isLocationPermissionGranted() async {
    bool isLocationGranted = false;

    var status = await Permission.locationAlways.status;
    if (!status.isGranted) {
      var status = await Permission.locationAlways.request();
      if (status.isGranted) {
        isLocationGranted = true;
      }
    } else {
      isLocationGranted = true;
    }
    return isLocationGranted;
  }

  Future<void> getLocation(BuildContext context) async {
    LocationData? loc;
    if (locationSubscription == null) {
      locationPCG.Location location = locationPCG.Location();
      location.changeSettings(
        accuracy: locationPCG.LocationAccuracy.high,
        distanceFilter: 1,
        interval: 2000,
      );
      locationSubscription = location.onLocationChanged.listen((newLoc) async {
        loc = newLoc;
        await setDriverData(newLoc);
      });
    } else {
      debugPrint("already listening to Location");
// updateTestDriverMarker(loc!);
    }
    notifyListeners();
  }

  /// function for updating driver live location on firebase
  Future<void> setDriverData(LocationData newLoc) async {
    if (newLoc.latitude != null &&
        newLoc.longitude != null &&
        driverFirebaseModel != null) {
      driverFirebaseModel?.location =
          GeoPoint(newLoc.latitude!, newLoc.longitude!);
      driverFirebaseModel?.heading = newLoc.heading;
// updateTestDriverMarker(newLoc);
      await FirebaseServices.setUserData(
          userFirebaseModel: driverFirebaseModel!,
          id: "${StaticInfo.driverModel?.driverFirebaseID ?? ""}");
    }
  }

  /// function for getting live location from firebase
  Future<void> driverFirebaseStream({required String firebaseUSerID}) async {
    if (firebaseUserStream == null) {
      String? driverFirebaseID =
          await FirebaseServices.checkUserInDB(firebaseUSerID);
      if (driverFirebaseID != null) {
        var value = FirebaseServices.fetchDriverStreamData(firebaseUSerID);

        firebaseUserStream = value.listen((event) async {
          driverFirebaseModel = event;
/*----------->>> Only update marker when fetched location and ride is started <<<-------*/
          if (event.location != null) {
// ------------>>>> Update Driver marker <<<<---------------
            updateDriverMarker(event);
          }
        });
      } else {
        debugPrint("user not found in firebase");
      }
    } else {
      debugPrint("stream already listening");
    }
    notifyListeners();
  }

  void setMorningEveningRoutes() {
    if (driverFirebaseModel?.morningShift != null &&
        rideStatusModel?.morningRideStatus == RideStatus.started) {
// set morning rotes
    } else if (driverFirebaseModel?.eveningShift != null &&
        rideStatusModel?.eveningRideStatus == RideStatus.started) {
// set evening rotes
    }
  }

  void updateDriverMarker(UserFirebaseModel event) {
    if (event.heading != null && event.location != null) {
      driverMarker[MarkerId('${StaticInfo.driverModel!.id}')] = Marker(
        rotation: event.heading!,
        markerId: MarkerId('${StaticInfo.driverModel!.id}'),
        position: LatLng(
          event.location!.latitude,
          event.location!.longitude,
        ),
        icon: carMarkerIcon,
      );
    }
    notifyListeners();
  }

  /// function which returns isDriver in given radius range or not
  Future<bool> isDriverInRadius({
    required double existingLat,
    required double existingLng,
    required double currentLat,
    required double currentLng,
    required double rangeInMeter,
  }) async {
    /// Create two Location objects for the coordinates
    final LocationData existingLocation = LocationData.fromMap({
      "latitude": existingLat,
      "longitude": existingLng,
    });
    final LocationData currentLocation = LocationData.fromMap({
      "latitude": currentLat,
      "longitude": currentLng,
    });

    /// Calculate the distance between the two points in meters
    final double distance = await Geolocator.distanceBetween(
      existingLocation.latitude!,
      existingLocation.longitude!,
      currentLocation.latitude!,
      currentLocation.longitude!,
    );
    debugPrint("existing location  ${existingLocation}");
    debugPrint("current location  ${currentLocation}");
    debugPrint("distance  ${distance}");
    debugPrint("range  ${rangeInMeter}");

    /// Set your desired threshold distance in meters
    /// Compare the distance with the threshold and determine if the coordinates are in the same area
    if (distance <= rangeInMeter) {
      return true;
    } else {
      return false;
    }
  }

  /// function for start timer
  Future<void> startTimer({required int childId}) async {
    /// this code is for find difference between 2 different DateTimes
// DateTime currentTime = DateTime.now();
// DateTime driverArrivedTime = driverTime;
// // int initialTime = driverArrivedTime.difference(currentTime).inSeconds;
// int initialTime = currentTime.difference(driverArrivedTime).inSeconds;
// print('=============================> time diff $initialTime');
// if(initialTime < 300){
    timerIsStartFor = childId;
    int? index = rideStatusModel?.childList
        ?.indexWhere((element) => (element.id == childId));
    remainingTimeInSeconds = 1;
    cancelTimer(timer);
    timer =
        Timer.periodic(Duration(seconds: countdownInSeconds), (timer) async {
      if (remainingTimeInSeconds <= 299) {
        remainingTimeInSeconds += countdownInSeconds;
        timeToDisplay = formatTime(remainingTimeInSeconds);

        /// after every 30 seconds update timer time on firebase
        if (remainingTimeInSeconds % 30 == 0) {
          print('============================ timer timer hit api');
          if (index != null) {
            rideStatusModel?.childList?[index].reamingTimerTimeInSeconds =
                remainingTimeInSeconds;
          }
          await FirebaseServices.setDriverRideStatus(
              rideStatusModel: rideStatusModel!);
        }
        notifyListeners();
      } else {
        timeToDisplay = '';
        cancelTimer(timer);
        notifyListeners();
      }
    });
// }
  }

  /// returns the formatted time for timer
  String formatTime(int timeInSeconds) {
    Duration duration = Duration(seconds: timeInSeconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void disposeFirebaseUserStream() {
    locationSubscription?.cancel();
    locationSubscription = null;
    cancelTimer(checkDriverIsInRadiusTimer);
  }

  void cancelTimer(Timer? timer) {
    if (timer != null) {
      if (timer.isActive) {
        timer.cancel();
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    firebaseUserStream?.cancel();
    firebaseUserStream = null;
    super.dispose();
  }
}
