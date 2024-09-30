import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pickup/models/user_firebase_model.dart';
import 'package:pickup/src/app/static_info.dart';

const String url = 'http://147.182.232.146:3000/';
// const String url = 'https://b3d6-182-185-226-52.ngrok-free.app';
const String baseUrl = '$url/api/v1/';

const String userExpired = "Not Authorized";

const String googleMapKey = 'xxxxxxxxxxxxxxxxxxxxxxxxx';

const double hMargin = 20;
const double vMargin = 12;
const double margin38 = 38;

const double margin18 = 18;
const double margin16 = 16;

const double logoH = 27;
const double logoW = 100;

Future<bool> check() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

List<int> successCodes = [200, 201, 202, 204];
